package com.restaurant.service;

import com.restaurant.dao.InvoiceDAO;
import com.restaurant.model.Invoice;
import com.restaurant.util.PdfInvoiceGenerator;

import java.io.OutputStream;
import java.util.List;

public class BillingService {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    public Invoice getInvoiceByOrderId(int orderId) {
        return invoiceDAO.getByOrderId(orderId);
    }

    public Invoice getInvoiceByNumber(String invoiceNumber) {
        return invoiceDAO.getByInvoiceNumber(invoiceNumber);
    }

    public List<Invoice> getInvoicesByRestaurant(int restaurantId) {
        return invoiceDAO.getByRestaurant(restaurantId);
    }

    public List<Invoice> getAllInvoices() {
        return invoiceDAO.getAll();
    }

    public void generateInvoicePdf(Invoice invoice, OutputStream out) throws Exception {
        PdfInvoiceGenerator.generateInvoicePdf(invoice, out);
    }
}

