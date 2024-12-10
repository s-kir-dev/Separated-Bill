//
//  ReadyOrdersViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 29.11.2024.
//

import UIKit
import Firebase

class ReadyOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var orders: [Order] = []
    let cafeID = UserDefaults.standard.string(forKey: "CafeID")!
    let db = Firestore.firestore()

    @IBOutlet weak var ordersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        ordersTableView.dataSource = self
        ordersTableView.delegate = self

        // Загружаем заказы при первом запуске
        loadOrders()

        // Таймер для обновления данных каждые 10 секунд
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(loadOrders), userInfo: nil, repeats: true)
    }

//    @objc private func loadOrders() {
//        print("Загружаю данные из Firestore...")
//
//        let db = Firestore.firestore()
//
//        // Получаем номера столов из UserDefaults
//        guard let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
//              let tableNumbers = try? JSONDecoder().decode([Int].self, from: savedData) else {
//            print("Table numbers not found in UserDefaults")
//            return
//        }
//
//        var fetchedOrders: [Order] = []
//        let dispatchGroup = DispatchGroup()
//
//        for tableNumber in tableNumbers {
//            print("Загружаю данные для стола №\(tableNumber)")
//
//            for clientIndex in 1...6 {
//                let clientID = "Client\(clientIndex)"
//                dispatchGroup.enter()
//
//                db.collection("\(cafeID)")
//                    .document("Table №\(tableNumber)")
//                    .collection("ready")
//                    .document(clientID)
//                    .collection("orderedProducts")
//                    .order(by: "timestamp", descending: true)
//                    .getDocuments { snapshot, error in
//                        defer { dispatchGroup.leave() }
//
//                        if let error = error {
//                            print("Error fetching orders for \(clientID) at Table №\(tableNumber): \(error)")
//                            return
//                        }
//
//                        guard let documents = snapshot?.documents else { return }
//
//                        for document in documents {
//                            // Получаем данные блюда из дочернего документа с названием блюда
//                            if let productName = document["productName"] as? String {
//                                self.loadProductDetails(productName: productName, tableNumber: tableNumber, clientID: clientID, documentID: document.documentID) { order in
//                                    if let order = order {
//                                        fetchedOrders.append(order)
//                                    }
//                                }
//                            }
//                        }
//                    }
//            }
//        }
//
//        // После завершения всех асинхронных запросов сортируем заказы
//        dispatchGroup.notify(queue: .main) {
//            print("Данные загружены, всего заказов: \(fetchedOrders.count)")
//
//            // Сортируем заказы по номеру стола и клиенту
//            self.orders = fetchedOrders.sorted {
//                if $0.tableNumber == $1.tableNumber {
//                    return $0.clientID < $1.clientID
//                }
//                return $0.tableNumber < $1.tableNumber
//            }
//
//            // Перезагружаем таблицу с отсортированными заказами
//            self.ordersTableView.reloadData()
//        }
//    }

    // Функция для загрузки дополнительных данных о продукте (из документа с именем продукта)
    
    @objc private func loadOrders() {
        print("Загружаю данные из коллекции ready...")

        // Загружаем номера столов из UserDefaults
        guard let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
              let tableNumbers = try? JSONDecoder().decode([Int].self, from: savedData) else {
            print("Номера столов не найдены в UserDefaults")
            return
        }

        var fetchedOrders: [Order] = []
        let dispatchGroup = DispatchGroup()

        // Перебираем номера столов
        for tableNumber in tableNumbers {
            print("Загружаю данные для стола №\(tableNumber)")

            // Перебираем клиентов (например, до 6 клиентов)
            for clientIndex in 1...6 {
                let clientID = "Client\(clientIndex)"
                dispatchGroup.enter()

                // Загружаем заказы из коллекции "ready" для каждого клиента
                db.collection("\(cafeID)")
                    .document("Table №\(tableNumber)")
                    .collection("ready")
                    .document(clientID)
                    .collection("orderedProducts")
                    .order(by: "timestamp", descending: true)
                    .getDocuments { snapshot, error in
                        defer { dispatchGroup.leave() }

                        if let error = error {
                            print("Ошибка при загрузке заказов для клиента \(clientID) на столе №\(tableNumber): \(error)")
                            return
                        }

                        guard let documents = snapshot?.documents else { return }

                        // Перебираем все документы (блюда) в коллекции "orderedProducts"
                        for document in documents {
                            if let order = self.parseOrderData(data: document.data(), tableNumber: tableNumber, clientID: clientID, documentID: document.documentID) {
                                fetchedOrders.append(order)
                            }
                        }
                    }
            }
        }

        // После завершения всех асинхронных запросов обновляем таблицу
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

    // MARK: - UITableView DataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Количество заказов в таблице: \(orders.count)")
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }

            let orderToDelete = self.orders[indexPath.row]

            let readyCollectionRef = self.db.collection(self.cafeID)
                .document("Table №\(orderToDelete.tableNumber)")
                .collection("ready")
                .document("Client\(orderToDelete.clientID)")
                .collection("orderedProducts")
                .document("\(orderToDelete.productName) order")

            readyCollectionRef.delete { error in
                if let error = error {
                    print("Error deleting ready order: \(error)")
                    completionHandler(false)
                } else {
                    print("Ready order deleted.")

                    // Удаляем заказ из массива и обновляем таблицу
                    self.orders.remove(at: indexPath.row)
                    self.ordersTableView.deleteRows(at: [indexPath], with: .fade)
                    completionHandler(true)
                }
            }
        }

        deleteAction.backgroundColor = .red.withAlphaComponent(0.5)
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readyOrdersCell", for: indexPath) as! OrdersTableViewCell
        let order = orders[indexPath.row]
        cell.productName.text = order.productName
        cell.productImage.image = UIImage(named: order.productImage)
        cell.clientNumber.text = "Клиент: \(order.clientID)"
        cell.tableNumber.text = "Стол: \(order.tableNumber)"

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
