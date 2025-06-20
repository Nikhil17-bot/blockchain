// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CertificateRevocation {
    address public admin;

    struct Certificate {
        string studentName;
        string course;
        uint256 issueDate;
        bool isRevoked;
    }

    mapping(bytes32 => Certificate) public certificates;

    event CertificateIssued(bytes32 certHash, string studentName, string course);
    event CertificateRevoked(bytes32 certHash);
    event CertificateUpdated(bytes32 certHash, string newCourse);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function issueCertificate(string memory studentName, string memory course, uint256 issueDate) public onlyAdmin {
        bytes32 certHash = keccak256(abi.encodePacked(studentName, course, issueDate));
        require(certificates[certHash].issueDate == 0, "Certificate already exists");
        certificates[certHash] = Certificate(studentName, course, issueDate, false);
        emit CertificateIssued(certHash, studentName, course);
    }

    function revokeCertificate(bytes32 certHash) public onlyAdmin {
        require(certificates[certHash].issueDate != 0, "Certificate not found");
        certificates[certHash].isRevoked = true;
        emit CertificateRevoked(certHash);
    }

    function getCertificate(bytes32 certHash) public view returns (Certificate memory) {
        require(certificates[certHash].issueDate != 0, "Certificate does not exist");
        return certificates[certHash];
    }

    function updateCourse(bytes32 certHash, string memory newCourse) public onlyAdmin {
        require(certificates[certHash].issueDate != 0, "Certificate not found");
        certificates[certHash].course = newCourse;
        emit CertificateUpdated(certHash, newCourse);
    }
}
