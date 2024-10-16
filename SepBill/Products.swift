//
//  Products.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 15.10.24.
//

import Foundation

struct Products {
    static var drinksWithoutAlcohol: [Product] = [ // 10
            Product(productImage: "Cola", productName: "Coca-Cola", productDescription: "Освежающий безалкогольный напиток с сахаром", productPrice: 2.50, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Orange Juice", productName: "Апельсиновый сок", productDescription: "Натуральный свежевыжатый апельсиновый сок", productPrice: 3.00, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Apple Juice", productName: "Яблочный сок", productDescription: "Натуральный сок из свежих яблок", productPrice: 3.00, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Mineral Water", productName: "Минеральная вода", productDescription: "Негазированная минеральная вода", productPrice: 2.00, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Green Tea", productName: "Зеленый чай", productDescription: "Освежающий зеленый чай с жасмином", productPrice: 3.00, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Herbal Tea", productName: "Травяной чай", productDescription: "Ароматный травяной чай с мятой и ромашкой", productPrice: 3.50, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Latte", productName: "Латте", productDescription: "Кофейный напиток с молоком", productPrice: 4.00, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Cappuccino", productName: "Капучино", productDescription: "Классический капучино с пенкой", productPrice: 4.50, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Smoothie", productName: "Смузи", productDescription: "Фруктовый смузи из ягод и банана", productPrice: 5.00, isSelected: false, productCategory: .drinksWithoutAlcohol),
            Product(productImage: "Lemonade", productName: "Лимонад", productDescription: "Домашний лимонад с лимоном и мятой", productPrice: 3.50, isSelected: false, productCategory: .drinksWithoutAlcohol)
    ]
        
    static var drinksWithAlcohol: [Product] = [ // 10
            Product(productImage: "Beer", productName: "Пиво", productDescription: "Освежающее светлое пиво", productPrice: 4.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Craft Beer", productName: "Крафтовое пиво", productDescription: "Авторское крафтовое пиво с выраженным вкусом хмеля", productPrice: 6.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Vodka", productName: "Водка", productDescription: "Традиционный крепкий алкогольный напиток", productPrice: 5.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Wine", productName: "Красное вино", productDescription: "Красное сухое вино из региона Бордо", productPrice: 12.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "White Wine", productName: "Белое вино", productDescription: "Белое сухое вино из Шардоне", productPrice: 10.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Sparkling Wine", productName: "Игристое вино", productDescription: "Шампанское брют", productPrice: 15.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Whiskey", productName: "Виски", productDescription: "Односолодовый шотландский виски", productPrice: 18.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Rum", productName: "Ром", productDescription: "Темный ром с нотками ванили", productPrice: 10.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Margarita", productName: "Маргарита", productDescription: "Коктейль на основе текилы с лаймом и солью", productPrice: 9.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Mojito", productName: "Мохито", productDescription: "Коктейль на основе рома с мятой и лаймом", productPrice: 8.00, isSelected: false, productCategory: .drinksWithAlcohol),
            Product(productImage: "Martini", productName: "Мартини", productDescription: "Версальский коктейль с оливкой", productPrice: 11.00, isSelected: false, productCategory: .drinksWithAlcohol)
    ]
    
    static var salats: [Product] = [ // 5
        Product(productImage: "Salat Tiffany", productName: "Салат \"Тиффарни\" с кальмарами", productDescription: "Кальмар, филе цыпленка, болгарский перец и листья салата под соусом \"Олива\" с помидорами, отварным яйцом и гренками из ржаного хлеба, маслинами, лимоном и зеленью. Особую пикантность салату придает фирменный соус", productPrice: 16.00, isSelected: false, productCategory: .salats),
        Product(productImage: "Fermer Salat", productName: "Салат из фермерских овощей", productDescription: "Томаты черри, перец свежий, огурцы свежие, лук красный, маслины, листья салата, соус \"Свежая зелень\" (Масло подсолнечное, Сахар, Соль, Уксус, Лук репчатый, Укроп свежий, Петрушка свежая, Чеснок свежий), лимон", productPrice: 15.00, isSelected: false, productCategory: .salats),
        Product(productImage: "Salat Cezar", productName: "Салат \"Цезарь\"", productDescription: "Филе цыпленка с помидоры и листьями салата под соусом \"Цезарь\" с гренками из пшеничного хлеба, сыром выдержанным и зеленью", productPrice: 16.00, isSelected: false, productCategory: .salats),
        Product(productImage: "Salat with beef", productName: "Салат с говядиной и овощами", productDescription: "Вырезка говяжья, маринованные огурцы, перец свежий, томаты черри, листья салата, лук, соус на основе оливкового масла и кетчупа , зелень", productPrice: 21.00, isSelected: false, productCategory: .salats),
        Product(productImage: "Salat with tough", productName: "Салат с языком", productDescription: "Язык говяжий, маринованные огурчики и отварное яйцо под майонезом, сыром и зеленью", productPrice: 12.00, isSelected: false, productCategory: .salats)
    ]
    
    static var hotMeatDishes: [Product] = [ // 4
        Product(productImage: "Steak Gov", productName: "Стейк из говядины", productDescription: "Вырезка говяжья, горчица, соевый соус, масло сливочное с зеленью, томаты черри, листья салата, зелень", productPrice: 29.00, isSelected: false, productCategory: .hotMeatDishes),
        Product(productImage: "Govyadina", productName: "Говядина в маринаде с травами с печеным картофелем и перцем", productDescription: "Говядина в соевом соусе с горчицей, розмарином и специями приготовленная на гриле, с дольками печеного картофеля и болгарского перца с зеленым сливочным маслом и листовым салатом", productPrice: 23.00, isSelected: false, productCategory: .hotMeatDishes),
        Product(productImage: "Svinina", productName: "Свинина с жареными лесными грибами", productDescription: "Свинина запеченная под сыром и майонезом, жареные лисички с репчатым луком, дольками жареного с базиликом картофеля на листьях салата со свежими помидорами ,огурцами и болгарским перцем", productPrice: 17.00, isSelected: false, productCategory: .hotMeatDishes),
        Product(productImage: "Steak Svinina", productName: "Стейк их свинины на косточке", productDescription: "Свинина (корейка на кости), соль, специи, горчица, соус соевый, розмарин, масло зеленое(Масло сливочное, Лимон свежий, Петрушка свежая, Соль пищевая), салат свежий, томат черри, руккола", productPrice: 17.00, isSelected: false, productCategory: .hotMeatDishes)
    ]
    
    static var hotFishDishes: [Product] = [ // 2
        Product(productImage: "File Heka", productName: "Филе хека жареное с золотистым картофелем и грибным соусом", productDescription: "Филе хека приготовленное на гриле с розмарином, дольки жареного картофеля со свежим укропом , под соусом из сливок, репчатого лука и шампиньонов", productPrice: 15.00, isSelected: false, productCategory: .hotFishDisches),
        Product(productImage: "Losos", productName: "Лосось-гриль с овощами и сливочным соусом", productDescription: "Лосось (филе), соль пищевая , специи, масло подсолнечное, сливки, сыр, горчица французская, перец свежий, кабачки свежие, баклажаны свежие, орегано, чеснок свежий, лимон свежий, зелень", productPrice: 30.00, isSelected: false, productCategory: .hotFishDisches)
    ]
    
    static var soups: [Product] = [ // 2
        Product(productImage: "Borsch", productName: "Борщ с пампушками и смальцем", productDescription: "Борщ украинский с отварной говядиной, сметаной и зеленью, пшеничные чесночно-пряные пампушки со шпиком и зеленым луком", productPrice: 6.00, isSelected: false, productCategory: .soups),
        Product(productImage: "Soup", productName: "Суп Том Ям с креветками", productDescription: "Тайский суп с шампиньонами, имбирем, чесноком, креветками, кокосовым молоком, томатом, луком-пореем, лаймом и острым перцем-чили", productPrice: 13.00, isSelected: false, productCategory: .soups),
        Product(productImage: "Solyanka", productName: "Солянка мясная", productDescription: "Ароматный суп с маринованными огурчиками, луком и мясными продуктами: языком, ветчиной и колбасой, со сметаной, маслинами, лимоном и зеленью", productPrice: 7.00, isSelected: false, productCategory: .soups)
    ]
    
    static var desserts: [Product] = [ // 5
        Product(productImage: "Bliny", productName: "Блинчики с творогом и клубничным соусом", productDescription: "Блинчики, Творог, Соус клубничный, Масло подсолнечное, Сахар, Яйца", productPrice: 8.00, isSelected: false, productCategory: .desserts),
        Product(productImage: "Ice-cream", productName: "Жареное мороженое в хрустящих хлопьях", productDescription: "Ванильный пломбир в хрустящей корочке с мятой.", productPrice: 5.00, isSelected: false, productCategory: .desserts),
        Product(productImage: "Red barhat", productName: "Дессерт \"Красный бархат\" с голубикой", productDescription: "Бисквит, сыр сливочный, сливки, вишневый соус, голубика, розмарин", productPrice: 7.00, isSelected: false, productCategory: .desserts),
        Product(productImage: "Tyramisu", productName: "Тирамису", productDescription: "Печенье бисквитное, крем на основе сыра маскарпоне , кофе, коньяк, мята, какао", productPrice: 8.00, isSelected: false, productCategory: .desserts),
        Product(productImage: "Napoleon", productName: "Наполеон", productDescription: "Тесто слоеное, крем заварной, ягоды свежие, соус клубничный, мята, сахарная пудра", productPrice: 7.00, isSelected: false, productCategory: .desserts)
    ]
    
    static var snacks: [Product] = [ // 5
        Product(productImage: "Cheese Plate", productName: "Сырная тарелка", productDescription: "Ассорти из различных видов сыра: чеддер, бри, горгонзола, подаётся с орехами и фруктами.", productPrice: 12.00, isSelected: false, productCategory: .snacks),
        Product(productImage: "Bruschetta", productName: "Брускетта с помидорами", productDescription: "Хрустящий хлеб с помидорами, базиликом и оливковым маслом.", productPrice: 6.00, isSelected: false, productCategory: .snacks),
        Product(productImage: "Onion Rings", productName: "Луковые кольца", productDescription: "Хрустящие кольца лука, обжаренные в кляре, подаются с соусом.", productPrice: 5.00, isSelected: false, productCategory: .snacks),
        Product(productImage: "Chicken Wings", productName: "Куриные крылышки", productDescription: "Острые крылышки, приготовленные на гриле, с соусом барбекю.", productPrice: 8.00, isSelected: false, productCategory: .snacks)
    ]
    
    static var pasta: [Product] = [ // 5
        Product(productImage: "Fetuchine", productName: "Фетуччине с цыпленком и грибами", productDescription: "Филе цыпленка с шампиньонами и луком в сливочном соусе с итальянской пастой, сыром выдержанным и зеленью", productPrice: 15.00, isSelected: false, productCategory: .pasta),
        Product(productImage: "Spagetti with seafood", productName: "Спагетти с морепродуктами", productDescription: "Мидии, креветки и семга в сливочном соусе с болгарским перцем, помидорами и луком - порем со спагетти, сыром и зеленью", productPrice: 18.00, isSelected: false, productCategory: .pasta),
        Product(productImage: "Carbonara", productName: "Спагетти \"Каробонара\"", productDescription: "Тонкие ломтики грудинки с чесноком в сливочном соусе с яйцом со спагетти, сыром выдержанным и зеленью", productPrice: 14.00, isSelected: false, productCategory: .pasta),
        Product(productImage: "Spagetti with chicken", productName: "Спагетти с курятиной и овощами", productDescription: "Филе цыпленка, болгарский перец, шампиньоны, лук - порей, мед и кайенский перец под соусом \"Бешамель\" со спагетти.", productPrice: 15.00, isSelected: false, productCategory: .pasta)
    ]
    let products: [[Product]] = [pasta, snacks, drinksWithAlcohol, drinksWithoutAlcohol, desserts, soups, salats, hotFishDishes, hotMeatDishes]
    func productCount() -> Int {
        return products.reduce(0) { $0 + $1.count }
    } // всего 48
    
}

