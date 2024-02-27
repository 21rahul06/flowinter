import FungibleToken from 0x05
import sor from 0x05

pub fun main(account: Address) {

    let publicVault: &sor.Vault{FungibleToken.Balance, FungibleToken.Receiver, sor.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&sor.Vault{FungibleToken.Balance, FungibleToken.Receiver, sor.CollectionPublic}>()

    if (publicVault == nil) {

        let newVault <- sor.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&sor.Vault{FungibleToken.Balance, FungibleToken.Receiver, sor.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        

        let retrievedVault: &sor.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&sor.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        let checkVault: &sor.Vault{FungibleToken.Balance, FungibleToken.Receiver, sor.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&sor.Vault{FungibleToken.Balance, FungibleToken.Receiver, sor.CollectionPublic}>()
                ?? panic("Vault capability not found")
        

        if sor.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a AlpToken vault")
        } else {
            log("This is not a AlpToken vault")
        }
    }
}
