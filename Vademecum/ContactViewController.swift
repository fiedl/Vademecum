import Contacts
import ContactsUI

extension CNContactViewController {

    // MARK: Initialization

    convenience init(vcfData: NSData) {
        do {
            // Read from local file:
            // let vcfData = NSData(contentsOfFile: "/Users/fiedl/Desktop/sven.vcf")

            let contact : CNContact = try CNContactVCardSerialization.contactsWithData(vcfData).first as! CNContact

            self.init(forUnknownContact: contact)

        } catch {
            fatalError("Could not convert vcfData into CNContact.")
        }
    }

}
