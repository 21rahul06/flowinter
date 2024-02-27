import FungibleToken from 0x05
import FlowToken from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the stackToken Minter reference
        let minter = signer.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
            ?? panic("You are not the stackToken minter")
        
        // Borrow the receiver's stackToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/FlowVault)
            .borrow()
            ?? panic("Error: Check your FlowToken Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintTokens(amount: amount)

        // Deposit minted tokens into the receiver's stackToken Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("stackToken minted and deposited successfully")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}