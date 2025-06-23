package edu.unialfa.hackathon.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class NotaPorDisciplinaDTO {
    private String nomeDisciplina;
    private List<NotaDTO> notas;
}
