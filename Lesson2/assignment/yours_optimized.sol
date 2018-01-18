/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    address owner;
//    Employee[] employees;
    mapping(address => Employee) employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    

    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];

    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {

        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var employee = employees[msg.sender];
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
