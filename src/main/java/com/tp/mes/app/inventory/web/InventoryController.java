package com.tp.mes.app.inventory.web;

import com.tp.mes.app.inventory.model.InventoryItem;
import com.tp.mes.app.inventory.model.InventoryStats;
import com.tp.mes.app.inventory.model.InventoryTransaction;
import com.tp.mes.app.inventory.service.InventoryService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.List;

/**
 * 재고 관리 컨트롤러
 */
@Controller
@RequestMapping("/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    /**
     * 재고 관리 대시보드
     */
    @GetMapping
    public String dashboard(Model model) {
        InventoryStats stats = inventoryService.getStats();
        List<InventoryItem> lowStockItems = inventoryService.getLowStockItems();
        List<InventoryTransaction> recentTransactions = inventoryService.getRecentTransactions(10);

        model.addAttribute("stats", stats);
        model.addAttribute("lowStockItems", lowStockItems);
        model.addAttribute("recentTransactions", recentTransactions);

        return "inventory/dashboard";
    }

    /**
     * 재고 목록
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) String type,
            Model model) {
        List<InventoryItem> items;

        if (keyword != null && !keyword.isEmpty()) {
            items = inventoryService.searchItems(keyword);
        } else if (type != null && !type.isEmpty()) {
            items = inventoryService.getItemsByType(type);
        } else {
            items = inventoryService.getAllItems();
        }

        model.addAttribute("items", items);
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedType", type);

        return "inventory/list";
    }

    /**
     * 재고 상세 정보
     */
    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        InventoryItem item = inventoryService.getItemById(id);
        List<InventoryTransaction> transactions = inventoryService.getTransactions(id);

        model.addAttribute("item", item);
        model.addAttribute("transactions", transactions);

        return "inventory/detail";
    }

    /**
     * 신규 재고 등록 폼
     */
    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("item", new InventoryItem());
        return "inventory/form";
    }

    /**
     * 재고 등록
     */
    @PostMapping
    public String create(@ModelAttribute InventoryItem item, Principal principal) {
        inventoryService.createItem(item);
        return "redirect:/inventory/list";
    }

    /**
     * 재고 수정 폼
     */
    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        InventoryItem item = inventoryService.getItemById(id);
        model.addAttribute("item", item);
        return "inventory/form";
    }

    /**
     * 재고 수정
     */
    @PostMapping("/{id}")
    public String update(@PathVariable Long id, @ModelAttribute InventoryItem item) {
        item.setInventoryId(id);
        inventoryService.updateItem(item);
        return "redirect:/inventory/" + id;
    }

    /**
     * 재고 입고
     */
    @PostMapping("/{id}/receive")
    public String receive(@PathVariable Long id,
            @RequestParam BigDecimal quantity,
            @RequestParam String reason,
            @RequestParam(required = false) String referenceNo,
            Principal principal) {
        String username = principal != null ? principal.getName() : "system";
        inventoryService.receiveStock(id, quantity, reason, referenceNo, username);
        return "redirect:/inventory/" + id;
    }

    /**
     * 재고 출고
     */
    @PostMapping("/{id}/issue")
    public String issue(@PathVariable Long id,
            @RequestParam BigDecimal quantity,
            @RequestParam String reason,
            @RequestParam(required = false) String referenceNo,
            Principal principal) {
        String username = principal != null ? principal.getName() : "system";
        inventoryService.issueStock(id, quantity, reason, referenceNo, username);
        return "redirect:/inventory/" + id;
    }

    /**
     * 재고 삭제
     */
    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        inventoryService.deleteItem(id);
        return "redirect:/inventory/list";
    }
}
