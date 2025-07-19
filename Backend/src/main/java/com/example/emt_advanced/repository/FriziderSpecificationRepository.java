package com.example.emt_advanced.repository;

import com.example.emt_advanced.model.FriziderProductSpecification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FriziderSpecificationRepository extends JpaRepository<FriziderProductSpecification, Long> {
    List<FriziderProductSpecification> findAllByProductId(Long id);
}

