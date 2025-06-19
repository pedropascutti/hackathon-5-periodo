package edu.unialfa.hackathon.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
public class Gabarito {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "id_prova", unique = true)
    private Prova prova;

    @OneToMany(mappedBy = "gabarito")
    private List<Questao> questoes = new ArrayList<>();
}
