package com.example.emt_advanced.service.impl;

import com.example.emt_advanced.model.InverterProduct;
import com.example.emt_advanced.model.InverterProductSpecification;
import com.example.emt_advanced.model.Product;
import com.example.emt_advanced.model.Specification;
import com.example.emt_advanced.model.dto.ProductDTO;
import com.example.emt_advanced.repository.InverterProductRepository;
import com.example.emt_advanced.repository.InverterSpecificationRepository;
import com.example.emt_advanced.service.ProductService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InverterProductServiceImpl implements ProductService {
    private final InverterProductRepository inverterProductRepository;
    private final InverterSpecificationRepository inverterSpecificationRepository;

    public InverterProductServiceImpl(InverterProductRepository inverterProductRepository, InverterSpecificationRepository inverterSpecificationRepository) {
        this.inverterProductRepository = inverterProductRepository;
        this.inverterSpecificationRepository = inverterSpecificationRepository;
    }

    @Override
    public List<InverterProduct> findAll() {
        return inverterProductRepository.findAll();
    }

    @Override
    public ProductDTO findById(Long id) {

        InverterProduct product=inverterProductRepository.findById(id).get();
        List<InverterProductSpecification> specs=inverterSpecificationRepository.findAllByProductId(id);

        return ProductDTO.from(product,specs);
    }

    @Override
    public List<? extends Product> findSimilar(Long id) {
        return inverterProductRepository.findProductsWithin5000OfChosen(id);
    }
}
