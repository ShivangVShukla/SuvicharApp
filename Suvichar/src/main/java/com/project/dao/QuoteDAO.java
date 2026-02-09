package com.project.dao;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.project.model.Quote;
import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class QuoteDAO {
    private static final String QUOTES_PATH = "D:/SuvicharData/quotes.xlsx";
    private static final String FAV_PATH = "D:/SuvicharData/favorites.xlsx";
    private static final String MASTER_PATH = "D:/SuvicharData/master_quotes.xlsx";

    // NEW METHOD: Fixes the "getAllQuotes is undefined" error
    public List<Quote> getAllQuotes() throws IOException {
        List<Quote> allQuotes = new ArrayList<>();
        File file = new File(MASTER_PATH);
        if (!file.exists()) return allQuotes;

        try (FileInputStream fis = new FileInputStream(file);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue; // Skip header
                String text = (row.getCell(0) != null) ? row.getCell(0).getStringCellValue() : "";
                String author = (row.getCell(1) != null) ? row.getCell(1).getStringCellValue() : "Unknown";
                if(!text.isEmpty()) allQuotes.add(new Quote(text, author));
            }
        }
        return allQuotes;
    }

    public synchronized void addQuote(String email, String text, String author) throws IOException {
        saveToFile(QUOTES_PATH, email, text, author);
    }

    public synchronized void saveToFavorites(String email, String text, String author) throws IOException {
        saveToFile(FAV_PATH, email, text, author);
    }

    public List<Quote> getFavorites(String userEmail) throws IOException {
        List<Quote> favorites = new ArrayList<>();
        File file = new File(FAV_PATH);
        if (!file.exists()) return favorites;
        try (FileInputStream fis = new FileInputStream(file);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;
                Cell emailCell = row.getCell(0);
                if (emailCell != null && emailCell.getStringCellValue().equalsIgnoreCase(userEmail)) {
                    String text = (row.getCell(1) != null) ? row.getCell(1).getStringCellValue() : "";
                    String author = (row.getCell(2) != null) ? row.getCell(2).getStringCellValue() : "Anonymous";
                    favorites.add(new Quote(text, author));
                }
            }
        }
        return favorites;
    }

    public List<Quote> getRandomMasterQuotes() throws IOException {
        List<Quote> allQuotes = getAllQuotes(); // Reusing the new method
        Collections.shuffle(allQuotes);
        return allQuotes.stream().limit(12).collect(Collectors.toList());
    }

    private void saveToFile(String path, String email, String text, String author) throws IOException {
        File file = new File(path);
        Workbook workbook;
        if (file.exists()) {
            try (FileInputStream fis = new FileInputStream(file)) {
                workbook = new XSSFWorkbook(fis);
            }
        } else {
            workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Data");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("UserEmail");
            header.createCell(1).setCellValue("QuoteText");
            header.createCell(2).setCellValue("Author");
        }
        Sheet sheet = workbook.getSheetAt(0);
        Row row = sheet.createRow(sheet.getLastRowNum() + 1);
        row.createCell(0).setCellValue(email);
        row.createCell(1).setCellValue(text);
        row.createCell(2).setCellValue(author);
        try (FileOutputStream fos = new FileOutputStream(file)) {
            workbook.write(fos);
        }
        workbook.close();
    }

    public synchronized void removeFavorite(String email, String text) throws IOException {
        File file = new File(FAV_PATH);
        if (!file.exists()) return;
        try (FileInputStream fis = new FileInputStream(file);
             Workbook workbook = new XSSFWorkbook(fis)) {
            Sheet sheet = workbook.getSheetAt(0);
            int rowToRemove = -1;
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;
                Cell emailCell = row.getCell(0);
                Cell textCell = row.getCell(1);
                if (emailCell != null && textCell != null &&
                    emailCell.getStringCellValue().equalsIgnoreCase(email) &&
                    textCell.getStringCellValue().equals(text)) {
                    rowToRemove = row.getRowNum();
                    break;
                }
            }
            if (rowToRemove != -1) {
                int lastRow = sheet.getLastRowNum();
                if (rowToRemove < lastRow) {
                    sheet.shiftRows(rowToRemove + 1, lastRow, -1);
                } else {
                    Row row = sheet.getRow(rowToRemove);
                    if (row != null) sheet.removeRow(row);
                }
                try (FileOutputStream fos = new FileOutputStream(file)) {
                    workbook.write(fos);
                }
            }
        }
    }
}