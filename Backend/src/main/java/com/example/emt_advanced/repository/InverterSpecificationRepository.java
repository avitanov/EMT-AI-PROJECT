package com.example.emt_advanced.repository;

import com.example.emt_advanced.model.InverterProductSpecification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InverterSpecificationRepository extends JpaRepository<InverterProductSpecification, Long> {

    List<InverterProductSpecification> findAllByProductId(Long id);

}
