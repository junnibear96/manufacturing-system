package com.tp.mes.app.inventory.repository;

import com.tp.mes.app.inventory.model.ProductBom;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ProductBomRepository {

    private final JdbcTemplate jdbcTemplate;

    public ProductBomRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<ProductBom> findByProductItemCode(String itemCode) {
        String sql = "SELECT b.bom_id, b.product_item_code, b.material_inventory_id, b.quantity_required, b.created_at, "
                +
                "m.material_name, m.material_id " +
                "FROM product_bom b " +
                "JOIN materials m ON b.material_inventory_id = m.material_id " +
                "WHERE b.product_item_code = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new ProductBom(
                rs.getLong("bom_id"),
                rs.getString("product_item_code"),
                rs.getString("material_inventory_id"),
                rs.getBigDecimal("quantity_required"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getString("material_name"),
                rs.getString("material_id")), itemCode);
    }
}
