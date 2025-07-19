package com.example.emt_advanced.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "inverteri_product")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper = true)
public class InverterProduct extends Product {

    @OneToMany(mappedBy = "product")
    private List<InverterProductSpecification> specifications;
}