package com.tp.mes.app.hr.controller;

import com.tp.mes.app.hr.model.Department;
import com.tp.mes.app.hr.model.Employee;
import com.tp.mes.app.hr.model.EmployeeListItem;
import com.tp.mes.app.hr.model.Position;
import com.tp.mes.app.hr.service.EmployeeService;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 인사관리 컨트롤러
 * TEMPORARILY DISABLED - HRM system being reimplemented
 */
@Controller
@RequestMapping("/hr")
public class HrController {

    private final EmployeeService employeeService;

    public HrController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    /**
     * 사원 목록 조회
     */
    @GetMapping("/employees")
    public String employeeList(
            @RequestParam(required = false) String department,
            @RequestParam(required = false) String status,
            Model model) {

        List<EmployeeListItem> employees;

        if (department != null && !department.isEmpty()) {
            employees = employeeService.getEmployeesByDepartment(department);
        } else if (status != null && !status.isEmpty()) {
            employees = employeeService.getEmployeesByStatus(status);
        } else {
            employees = employeeService.getAllEmployees();
        }

        // 필터용 부서 목록
        List<Department> departments = employeeService.getAllDepartments();

        model.addAttribute("employees", employees);
        model.addAttribute("departments", departments);
        model.addAttribute("selectedDepartment", department);
        model.addAttribute("selectedStatus", status);

        return "hr/employee-list";
    }

    /**
     * 사원 등록 폼
     */
    @GetMapping("/employees/new")
    public String employeeForm(Model model) {
        List<Department> departments = employeeService.getAllDepartments();
        List<Position> positions = employeeService.getAllPositions();

        model.addAttribute("departments", departments);
        model.addAttribute("positions", positions);
        model.addAttribute("mode", "new");

        return "hr/employee-form";
    }

    /**
     * 사원 등록 처리
     */
    @PostMapping("/employees")
    public String createEmployee(
            @RequestParam String empId,
            @RequestParam String empName,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            @RequestParam String departmentId,
            @RequestParam String positionId,
            @RequestParam(defaultValue = "OFFICE") String jobType,
            @RequestParam(required = false) String shiftType,
            @RequestParam(required = false) Integer skillLevel,
            RedirectAttributes redirectAttributes) {

        // Employee Record 생성
        Employee employee = new Employee(
                empId,
                empName,
                email,
                phone,
                LocalDate.now(), // hireDate
                null, // birthDate
                null, // gender
                departmentId,
                positionId,
                jobType,
                null, // managerEmpId
                "ACTIVE", // status
                null, // leaveStartDate
                null, // leaveEndDate
                null, // terminationDate
                null, // terminationReason
                shiftType,
                null, // factoryId
                null, // productionLineId
                skillLevel,
                null, // createdAt
                null // updatedAt
        );

        employeeService.createEmployee(employee);

        redirectAttributes.addFlashAttribute("message", "사원이 등록되었습니다: " + empName);
        return "redirect:/hr/employees";
    }

    /**
     * 사원 상세/수정 폼
     */
    @GetMapping("/employees/{empId}")
    public String employeeDetail(@PathVariable String empId, Model model) {
        Employee employee = employeeService.getEmployeeById(empId)
                .orElseThrow(() -> new IllegalArgumentException("사원을 찾을 수 없습니다: " + empId));

        List<Department> departments = employeeService.getAllDepartments();
        List<Position> positions = employeeService.getAllPositions();
        List<String> roles = employeeService.getEmployeeRoles(empId);

        model.addAttribute("employee", employee);
        model.addAttribute("departments", departments);
        model.addAttribute("positions", positions);
        model.addAttribute("roles", roles);
        model.addAttribute("mode", "edit");

        return "hr/employee-form";
    }

    /**
     * 사원 정보 수정 처리
     */
    @PostMapping("/employees/{empId}")
    public String updateEmployee(
            @PathVariable String empId,
            @RequestParam String empName,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            @RequestParam String departmentId,
            @RequestParam String positionId,
            @RequestParam(defaultValue = "OFFICE") String jobType,
            @RequestParam(required = false) String shiftType,
            @RequestParam(required = false) Integer skillLevel,
            @RequestParam String status,
            RedirectAttributes redirectAttributes) {

        // 기존 사원 정보 조회
        Employee existing = employeeService.getEmployeeById(empId)
                .orElseThrow(() -> new IllegalArgumentException("사원을 찾을 수 없습니다: " + empId));

        // 수정된 정보로 새 Record 생성
        Employee updated = new Employee(
                empId,
                empName,
                email,
                phone,
                existing.getHireDate(),
                existing.getBirthDate(),
                existing.getGender(),
                departmentId,
                positionId,
                jobType,
                existing.getManagerEmpId(),
                status,
                existing.getLeaveStartDate(),
                existing.getLeaveEndDate(),
                existing.getTerminationDate(),
                existing.getTerminationReason(),
                shiftType,
                existing.getFactoryId(),
                existing.getProductionLineId(),
                skillLevel,
                existing.getCreatedAt(),
                null // updatedAt은 DB에서 자동 갱신
        );

        employeeService.updateEmployee(updated);

        redirectAttributes.addFlashAttribute("message", "사원 정보가 수정되었습니다: " + empName);
        return "redirect:/hr/employees/" + empId;
    }

    /**
     * 재직 상태 변경
     */
    @PostMapping("/employees/{empId}/status")
    public String changeStatus(
            @PathVariable String empId,
            @RequestParam String status,
            @RequestParam(required = false) String reason,
            RedirectAttributes redirectAttributes) {

        employeeService.changeEmployeeStatus(empId, status, reason);

        redirectAttributes.addFlashAttribute("message", "재직 상태가 변경되었습니다: " + status);
        return "redirect:/hr/employees/" + empId;
    }
}

