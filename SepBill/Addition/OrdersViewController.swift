//  OrdersViewController.swift
//  SepBill
//  Created by Кирилл Сысоев on 29.11.2024.

import UIKit
import Firebase

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    private var orders: [Order] = []
    private let cafeID = UserDefaults.standard.string(forKey: "CafeID") ?? ""
    private let db = Firestore.firestore()

    @IBOutlet weak var ordersTableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadOrders()

        // Timer to refresh data every 10 seconds
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(loadOrders), userInfo: nil, repeats: true)
    }

    // MARK: - Setup
    private func setupTableView() {
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        ordersTableView.tableFooterView = UIView() // Убираем пустые строки
    }

    // MARK: - Data Loading
    @objc private func loadOrders() {
        print("Загружаю данные")

        // Load table numbers from UserDefaults
        guard let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
              let tableNumbers = try? JSONDecoder().decode([Int].self, from: savedData) else {
            print("Table numbers not found in UserDefaults")
            return
        }

        var fetchedOrders: [Order] = []
        let dispatchGroup = DispatchGroup()

        for tableNumber in tableNumbers {
            print("Загружаю данные для стола №\(tableNumber)")

            for clientIndex in 1...6 {
                let clientID = "Client\(clientIndex)"
                dispatchGroup.enter()

                db.collection("\(cafeID)")
                    .document("Table №\(tableNumber)")
                    .collection("orders")
                    .document(clientID)
                    .collection("orderedProducts")
                    .order(by: "timestamp", descending: true)
                    .getDocuments { snapshot, error in
                        defer { dispatchGroup.leave() }

                        if let error = error {
                            print("Error fetching orders for \(clientID) at Table №\(tableNumber): \(error)")
                            return
                        }

                        guard let documents = snapshot?.documents else { return }

                        for document in documents {
                            if let order = self.parseOrderData(data: document.data(), tableNumber: tableNumber, clientID: clientID, documentID: document.documentID) {
                                fetchedOrders.append(order)
                            }
                        }
                    }
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("Данные загружены, всего заказов: \(fetchedOrders.count)")
            self.orders = fetchedOrders
            self.ordersTableView.reloadData()
        }
    }

    private func parseOrderData(data: [String: Any], tableNumber: Int, clientID: String, documentID: String) -> Order? {
        guard let productName = data["productName"] as? String,
              let clientNumber = data["b clientNumber"] as? Int,
              let tableNumber = data["a tableNumber"] as? Int,
              let productImage = data["productImage"] as? String,
              let productDescription = data["productDescription"] as? String,
              let productPrice = data["productPrice"] as? Double,
              let productCategoryRaw = data["productCategory"] as? Int,
              let productCategory = Category(rawValue: productCategoryRaw),
              let productQuantity = data["productQuantity"] as? Int else {
            return nil
        }

        return Order(
            productImage: productImage,
            productName: productName,
            productDescription: productDescription,
            productPrice: productPrice,
            productQuantity: productQuantity,
            clientID: clientNumber,
            tableNumber: tableNumber,
            productCategory: productCategory
        )
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as? OrdersTableViewCell else {
            return UITableViewCell()
        }

        let order = orders[indexPath.row]
        cell.productName.text = order.productName
        cell.productImage.image = UIImage(named: order.productImage)
        cell.selectionStyle = .none

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let readyAction = UIContextualAction(style: .destructive, title: "Готово") { [weak self] (_, _, completionHandler) in
            self?.markOrderAsReady(at: indexPath, completionHandler: completionHandler)
        }

        readyAction.backgroundColor = .green.withAlphaComponent(0.5)
        readyAction.image = UIImage(systemName: "checkmark.seal.fill")

        return UISwipeActionsConfiguration(actions: [readyAction])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }

    // MARK: - Order Management
    private func markOrderAsReady(at indexPath: IndexPath, completionHandler: @escaping (Bool) -> Void) {
        let order = orders[indexPath.row]

        // Получаем имя клиента по порядковому номеру
        let clientID = "Client\(order.clientID)" // Например, "Client1", "Client2" и т.д.

        // Ссылка на документ заказа в текущей коллекции
        let orderDocumentRef = db.collection(cafeID)
            .document("Table №\(order.tableNumber)")
            .collection("orders")
            .document(clientID)
            .collection("orderedProducts")
            .document("\(order.productName) order")

        // Ссылка на коллекцию "ready" для того же клиента
        let readyCollectionRef = db.collection(cafeID)
            .document("Table №\(order.tableNumber)")
            .collection("ready")
            .document(clientID) // Документ клиента в коллекции "ready"
            .collection("orderedProducts")
            .document("\(order.productName) order")

        // Переносим заказ в коллекцию "ready"
        readyCollectionRef.setData([
            "productImage": order.productImage,
            "productName": order.productName,
            "productDescription": order.productDescription,
            "productPrice": order.productPrice,
            "productQuantity": order.productQuantity,
            "b clientNumber": order.clientID,
            "a tableNumber": order.tableNumber,
            "productCategory": order.productCategory.rawValue,
            "timestamp": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            if let error = error {
                print("Ошибка переноса заказа: \(error.localizedDescription)")
                completionHandler(false)
                return
            }

            print("Заказ успешно добавлен в коллекцию ready для \(clientID)")

            // Удаляем заказ из коллекции orderedProducts
            orderDocumentRef.delete { error in
                if let error = error {
                    print("Ошибка при удалении заказа: \(error.localizedDescription)")
                    completionHandler(false)
                    return
                }

                print("Заказ успешно удален из текущей коллекции")

                // Обновляем данные в таблице
                self?.orders.remove(at: indexPath.row)
                self?.ordersTableView.deleteRows(at: [indexPath], with: .fade)

                // Загружаем данные заново
                self?.loadOrders()
                completionHandler(true)
            }
        }
    }
}
