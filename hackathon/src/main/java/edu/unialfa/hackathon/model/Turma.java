package edu.unialfa.hackathon.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
public class Turma {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    @OneToMany(mappedBy = "turma")
    private List<Disciplina> disciplinas = new ArrayList<>();

    @OneToMany(mappedBy = "turma")
    private List<Aluno> alunos = new ArrayList<>();
}
