package com.example.emt_advanced.service;

import com.example.emt_advanced.model.Product;
import com.example.emt_advanced.model.dto.ProductDTO;

import java.util.List;

public interface ProductService<T extends Product> {
    List<T> findAll();
    ProductDTO findById(Long id);
    T findProduct(Long id);
    List<T> findSimilar(Long id);

}
