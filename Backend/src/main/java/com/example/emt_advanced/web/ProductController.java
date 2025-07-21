package com.example.emt_advanced.web;

import com.example.emt_advanced.model.FriziderProduct;
import com.example.emt_advanced.model.InverterProduct;
import com.example.emt_advanced.model.Product;
import com.example.emt_advanced.model.dto.ProductDTO;
import com.example.emt_advanced.service.GeminiService;
import com.example.emt_advanced.service.ProductService;
import com.example.emt_advanced.service.impl.FriziderProductServiceImpl;
import com.example.emt_advanced.service.impl.InverterProductServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@Tag(name = "Product API", description = "Endpoints for managing products")
public class ProductController {

    private final ProductService friziderProductService;
    private final ProductService inverterProductService;
    private final GeminiService geminiService;

    public ProductController(FriziderProductServiceImpl friziderProductService, InverterProductServiceImpl inverterProductService,GeminiService geminiService) {
        this.friziderProductService = friziderProductService;
        this.inverterProductService = inverterProductService;
        this.geminiService=geminiService;
    }

    @Operation(summary = "Get all products", description = "Retrieves a list of all available products.")
    @GetMapping("/frizideri")
    public List<? extends Product> findAll() {
        return friziderProductService.findAll();
    }
    @Operation(summary = "Get product by ID", description = "Finds a product by its ID.")
    @GetMapping("/frizideri/{id}")
    public ResponseEntity<ProductDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(friziderProductService.findById(id));
    }
    @Operation(summary = "Get all products", description = "Retrieves a list of all available products.")
    @GetMapping("/inverteri")
    public List<? extends Product> findAllInverteri() {
        return inverterProductService.findAll();
    }
    @Operation(summary = "Get product by ID", description = "Finds a product by its ID.")
    @GetMapping("/inverteri/{id}")
    public ResponseEntity<ProductDTO> findInverterById(@PathVariable Long id) {
        return ResponseEntity.ok(inverterProductService.findById(id));
    }
    @GetMapping("/inverteri/{id}/findSimilar")
    public List<ProductDTO> findSimilarInverteri(@PathVariable Long id) {
        return geminiService.findSimilarProducts(id,"inverteri");
    }
    @GetMapping("/frizideri/{id}/findSimilar")
    public List<ProductDTO> findSimilarFrizideri(@PathVariable Long id) {
        return geminiService.findSimilarProducts(id,"frizideri");
    }

//    @GetMapping("/paginated")
//    public ResponseEntity<Page<DisplayProductDto>> findAll(Pageable pageable) {
//        return ResponseEntity.ok(productApplicationService.findAll(pageable));
//    }



}

