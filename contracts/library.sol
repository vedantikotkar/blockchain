// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Library {
    struct Book {
        string title;
        string author;
        string genre;
        bool isBorrowed;
        uint256 price; 
    }

    mapping(uint256 => Book) public books;
    uint256 public totalBooks;

    event BookAdded(uint256 indexed bookId, string title, string author, string genre, uint256 price);
    event BookDeleted(uint256 indexed bookId);
    event BookUpdated(uint256 indexed bookId, string title, string author, string genre, uint256 price);
    event BookBorrowed(uint256 indexed bookId);
    event BookReturned(uint256 indexed bookId);
    event BookPurchased(uint256 indexed bookId);

    function addBook(string memory title, string memory author, string memory genre, uint256 price) public {
        totalBooks++;
        books[totalBooks] = Book(title, author, genre, false, price);
        emit BookAdded(totalBooks, title, author, genre, price);
    }

    function deleteBook(uint256 bookId) public {
        require(bookId > 0 && bookId <= totalBooks, "Invalid book ID");
        delete books[bookId];
        totalBooks--; 
        emit BookDeleted(bookId);
    }

    function updateBook(uint256 bookId, string memory title, string memory author, string memory genre, uint256 price) public {
        require(bookId > 0 && bookId <= totalBooks, "Invalid book ID");
        Book storage book = books[bookId];
        book.title = title;
        book.author = author;
        book.genre = genre;
        book.price = price;
        emit BookUpdated(bookId, title, author, genre, price);
    }

    function getBook(uint256 bookId) public view returns (string memory, string memory, string memory, bool, uint256) {
        require(bookId > 0 && bookId <= totalBooks, "Invalid book ID");
        Book memory book = books[bookId];
        return (book.title, book.author, book.genre, book.isBorrowed, book.price);
    }

    function borrowBook(uint256 bookId) public {
        require(bookId > 0 && bookId <= totalBooks, "Invalid book ID");
        require(!books[bookId].isBorrowed, "Book already borrowed");
        books[bookId].isBorrowed = true;
        emit BookBorrowed(bookId);
    }

    function returnBook(uint256 bookId) public {
        require(bookId > 0 && bookId <= totalBooks, "Invalid book ID");
        require(books[bookId].isBorrowed, "Book not borrowed");
        books[bookId].isBorrowed = false;
        emit BookReturned(bookId);
    }

    function purchaseBook(uint256 bookId) public payable {
        require(bookId > 0 && bookId <= totalBooks, "Invalid book ID");
        Book storage book = books[bookId];
        require(!book.isBorrowed, "Book is already borrowed");
        require(msg.value >= book.price, "Insufficient funds");

        // Transfer the price to the seller
        payable(msg.sender).transfer(book.price);
        emit BookPurchased(bookId);
    }

    function getTotalBooks() public view returns (uint256) {
        return totalBooks;
    }

    // Search books by title
    function searchBooksByTitle(string memory _title) public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](totalBooks);
        uint256 counter = 0;
        for (uint256 i = 1; i <= totalBooks; i++) {
            if (compareStrings(books[i].title, _title)) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // Search books by author
    function searchBooksByAuthor(string memory _author) public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](totalBooks);
        uint256 counter = 0;
        for (uint256 i = 1; i <= totalBooks; i++) {
            if (compareStrings(books[i].author, _author)) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // Search books by genre
    function searchBooksByGenre(string memory _genre) public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](totalBooks);
        uint256 counter = 0;
        for (uint256 i = 1; i <= totalBooks; i++) {
            if (compareStrings(books[i].genre, _genre)) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // Internal function to compare strings
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}
