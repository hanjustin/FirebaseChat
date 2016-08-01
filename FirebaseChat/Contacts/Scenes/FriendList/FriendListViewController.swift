
import UIKit

class FriendListViewController: UIViewController {
    private enum Section: Int {
        case friendRequest
        case friendList
        
        static let count = 2
    }
    
    private let sectionTitle = ["Friend Request", "Friend List"]
    private var sectionIsExpanded = [false, false]
    private var friendRequestSenders: [User] = [] {
        didSet {
            friendRequestSenders.sort { $0.name < $1.name }
            let section = Section.friendRequest.rawValue
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
    
    private var friends: [User] = [] {
        didSet {
            friends.sort { $0.name < $1.name }
            let section = Section.friendList.rawValue
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }

    @IBOutlet private weak var tableView: UITableView!

    private lazy var friendRequestsObserver: DatabaseObserver = DatabaseObserver(rootRef: .user_FriendRequests, ObjectID: self.signedInUserID)
    private lazy var friendListObserver: DatabaseObserver = DatabaseObserver(rootRef: .user_Friends, ObjectID: self.signedInUserID)
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        createSignOutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startFriendListObservation()
        startFriendRequestObservation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetSectionData()
        friendListObserver.stopAllObservings()
        friendRequestsObserver.stopAllObservings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController
        switch destinationVC {
        case let destinationVC as FriendRequestViewController:
            guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
            destinationVC.isSendingFriendRequest = false
            destinationVC.user = friendRequestSenders[selectedRow]
            
        case let destinationVC as FriendProfileViewController:
            guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
            destinationVC.friend = friends[selectedRow]
            
        default:
            break
        }
    }
    
    func signOut(sender: UIBarButtonItem) {
        do {
            try AuthManager.sharedInstance.signOut()
            
            guard let signInVC = UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController() else { return }
            
            present(signInVC, animated: true, completion: nil)
        } catch let error as NSError {
            presentOKAlertWith(title: "Sign Out Failed", message: error.localizedDescription)
        }
    }
}

// MARK: - Private Methods

private extension FriendListViewController {
    func createSignOutButton() {
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        signOutButton.tintColor = UIColor.red()
        navigationItem.leftBarButtonItem = signOutButton
    }
    
    func setupTableView() {
        let sectionHeader = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(sectionHeader, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        tableView.hideBottomEmptyCellsWithBlankFooter()
    }
    
    func startFriendListObservation() {
        friendListObserver.dereferenceIDIndexTo(
            type: User.self,
            currentListHandler: handleFriendList,
            newObjectHandler: handleAddedFriend)
    }
    
    func handleFriendList(friends: [User]) {
        self.friends = friends
    }
    
    func handleAddedFriend(friend: User) {
        friends.append(friend)
    }
    
    func startFriendRequestObservation() {
        friendRequestsObserver.dereferenceIDIndexTo(
            type: User.self,
            currentListHandler: handleFriendRequestList,
            newObjectHandler: handleAddedFriendRequest)
    }
    
    func handleFriendRequestList(requestSenders: [User]) {
        friendRequestSenders = requestSenders
    }
    
    func handleAddedFriendRequest(requestSender: User) {
        friendRequestSenders.append(requestSender)
    }
    
    func itemsFor(section: Int) -> [User] {
        guard let section = Section(rawValue: section) else { fatalError("Invalid Section") }
        
        let users: [User]
        switch section {
        case .friendList: users = friends
        case .friendRequest: users = friendRequestSenders
        }
        
        return users
    }
    
    func resetSectionData() {
        friends = []
        friendRequestSenders = []
    }

    var signedInUserID: String! {
        return AuthManager.sharedInstance.signedInUser?.uniqueID
    }
}

// MARK: - UITableViewDataSource

extension FriendListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionIsExpanded[section] ? itemsFor(section: section).count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let users = itemsFor(section: indexPath.section)
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user.email
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
}

// MARK: - UITableViewDelegate

extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid Section") }
        
        switch section {
        case .friendRequest: performSegue(withIdentifier: "ShowFriendRequestVC", sender: nil)
        case .friendList: performSegue(withIdentifier: "ShowFriendProfileVC", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(TableSectionHeader)) as? TableSectionHeader
        header?.section = section
        header?.signLabel.text = sectionIsExpanded[section] ? "-" : "+"
        header?.titleLabel.text = sectionTitle[section]
        header?.delegate = self
        
        return header
    }
}

// MARK: - TableSectionHeaderDelegate

extension FriendListViewController: TableSectionHeaderDelegate {
    func didTapHeaderForSection(_ section: Int) {
        sectionIsExpanded[section].toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
