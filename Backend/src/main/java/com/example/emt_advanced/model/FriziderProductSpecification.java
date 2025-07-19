package com.example.emt_advanced.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "frizideri_product_specification")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper = true)
public class FriziderProductSpecification extends Specification {

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private FriziderProduct product;
}
