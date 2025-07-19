package com.example.emt_advanced.service;

import com.example.emt_advanced.model.Product;
import com.example.emt_advanced.model.dto.ProductDTO;

import java.util.List;

public interface ProductService {
    List<? extends Product> findAll();
    ProductDTO findById(Long id);
}
