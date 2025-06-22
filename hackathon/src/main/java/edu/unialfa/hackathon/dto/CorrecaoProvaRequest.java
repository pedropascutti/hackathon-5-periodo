package edu.unialfa.hackathon.dto;

import lombok.Data;

import java.util.List;

@Data
public class CorrecaoProvaRequest {
    private Long idProva;
    private Long idAluno;
    private List<RespostaSimplesDTO> respostas;
}
