import FungibleToken from 0x05
import sor from 0x05

pub fun main(account: Address) {

    let publicVault = getAccount(account)
        .getCapability(/public/Vault)
        .borrow<&sor.Vault{FungibleToken.Balance}>()
        ?? panic("Vault not found, setup might be incomplete")

    log("Vault setup verified successfully")
}
