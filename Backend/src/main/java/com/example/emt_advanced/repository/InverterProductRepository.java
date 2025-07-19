package com.example.emt_advanced.repository;

import com.example.emt_advanced.model.InverterProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InverterProductRepository extends JpaRepository<InverterProduct, Long> {}
