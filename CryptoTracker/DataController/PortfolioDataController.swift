//
//  PortfolioDataController.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 8/1/2023.
//

import CoreData
import Foundation


class PortfolioDataController {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioModel"
    private let entityName: String = "PortfolioEntity"

    @Published var savedEntities: [PortfolioEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading core data, \(error.localizedDescription)")
            }
        }
        self.getPortfolio()
    }

    // MARK: Public
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: { (savedEntity) -> Bool in
            return savedEntity.coinID == coin.id
        }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            addPortfolio(coin: coin, amount: amount)
        }
    }

    // MARK: Private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching coredata, \(error.localizedDescription)")
        }
    }

    private func addPortfolio(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }

    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }

    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving coredata, \(error)")
        }
    }

    private func applyChanges() {
        save()
        getPortfolio()
    }
}
