package com.example.emt_advanced.model;

import jakarta.persistence.*;
import lombok.*;

@MappedSuperclass
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public abstract class Specification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    protected Long id;

    @Column(name = "spec_text", nullable = false)
    protected String specificationText;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSpecificationText() {
        return specificationText;
    }

    public void setSpecificationText(String specificationText) {
        this.specificationText = specificationText;
    }
}
