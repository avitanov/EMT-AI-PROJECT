package com.example.emt_advanced.repository;

import com.example.emt_advanced.model.FriziderProduct;
import com.example.emt_advanced.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FriziderProductRepository extends JpaRepository<FriziderProduct, Long> {}

