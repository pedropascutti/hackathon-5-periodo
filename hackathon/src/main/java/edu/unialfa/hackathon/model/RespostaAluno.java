package edu.unialfa.hackathon.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class RespostaAluno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_aluno", nullable = false)
    private Aluno aluno;

    @ManyToOne
    @JoinColumn(name = "id_prova", nullable = false)
    private Prova prova;

    private String numeroQuestao;

    private String alternativaEscolhida;

    private boolean correta;
}
