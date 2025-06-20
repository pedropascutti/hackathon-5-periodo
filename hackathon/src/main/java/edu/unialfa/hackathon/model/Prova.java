package edu.unialfa.hackathon.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
public class Prova {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate data;

    @ManyToOne
    @JoinColumn(name = "id_disciplina")
    private Disciplina disciplina;

    @OneToMany(mappedBy = "prova")
    private List<Questao> questoes = new ArrayList<>();
}
