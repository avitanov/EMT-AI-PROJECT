package com.example.emt_advanced.repository;

import com.example.emt_advanced.model.FriziderProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;


@Repository
public interface FriziderProductRepository extends JpaRepository<FriziderProduct, Long> {
    @Query("""
        SELECT p
          FROM FriziderProduct p, FriziderProduct c
         WHERE c.id = :chosenId
           AND p.priceMkd BETWEEN c.priceMkd - 3000 AND c.priceMkd + 3000
           AND p.id <> :chosenId
        """)
    List<FriziderProduct> findProductsWithin5000OfChosen(@Param("chosenId") Long chosenId);
}

