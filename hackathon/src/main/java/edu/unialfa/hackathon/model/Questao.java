package edu.unialfa.hackathon.model;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;

@Entity
@Data
public class Questao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private BigDecimal pontuacao;

    private String alternativaCorreta;

    @ManyToOne
    @JoinColumn(name = "id_gabarito")
    private Gabarito gabarito;
}
