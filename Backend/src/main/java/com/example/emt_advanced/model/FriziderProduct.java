package com.example.emt_advanced.model;

import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "frizideri_product")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper = true)
public class FriziderProduct extends Product {

    @OneToMany(mappedBy = "product")
    private List<FriziderProductSpecification> specifications;
}