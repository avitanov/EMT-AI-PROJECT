package com.example.emt_advanced.service.impl;

import com.example.emt_advanced.model.FriziderProduct;
import com.example.emt_advanced.model.FriziderProductSpecification;
import com.example.emt_advanced.model.Product;
import com.example.emt_advanced.model.Specification;
import com.example.emt_advanced.model.dto.ProductDTO;
import com.example.emt_advanced.repository.FriziderProductRepository;
import com.example.emt_advanced.repository.FriziderSpecificationRepository;
import com.example.emt_advanced.service.ProductService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FriziderProductServiceImpl implements ProductService {
    private final FriziderProductRepository friziderProductRepository;
    private final FriziderSpecificationRepository friziderSpecificationRepository;

    public FriziderProductServiceImpl(FriziderProductRepository friziderProductRepository, FriziderSpecificationRepository friziderSpecificationRepository) {
        this.friziderProductRepository = friziderProductRepository;
        this.friziderSpecificationRepository = friziderSpecificationRepository;
    }

    @Override
    public List<FriziderProduct> findAll() {
        return friziderProductRepository.findAll();
    }

    @Override
    public ProductDTO findById(Long id) {
        FriziderProduct product=friziderProductRepository.findById(id).get();
        List<FriziderProductSpecification> specs=friziderSpecificationRepository.findAllByProductId(id);

        return ProductDTO.from(product,specs);
    }

    @Override
    public List<? extends Product> findSimilar(Long id) {
        return friziderProductRepository.findProductsWithin5000OfChosen(id);
    }
}
