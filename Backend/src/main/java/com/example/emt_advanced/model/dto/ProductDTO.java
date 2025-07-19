package com.example.emt_advanced.model.dto;

import com.example.emt_advanced.model.Product;
import com.example.emt_advanced.model.Specification;

import java.util.List;

public record ProductDTO(

        Long id,
        String website,
        String productName,
        Integer price,
        String ImageUrl,
        List<? extends Specification> specificationList
) {
    public static ProductDTO from(Product product,List<? extends Specification> specs){
        return new ProductDTO(product.getId(),product.getWebsite(),product.getProductName(),
                product.getPriceMkd(),
                product.getImageUrl(),
                specs
                );
    }
}
