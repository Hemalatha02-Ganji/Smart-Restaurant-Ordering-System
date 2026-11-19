package com.restaurant.util;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import com.lowagie.text.pdf.draw.LineSeparator;
import com.restaurant.model.Invoice;
import com.restaurant.model.OrderItem;

import java.awt.Color;
import java.io.OutputStream;
import java.text.SimpleDateFormat;

/**
 * Enterprise PDF Digital Invoice Generator using OpenPDF.
 * Generates beautifully formatted, printable invoices for restaurant orders.
 */
public class PdfInvoiceGenerator {

    private static final Color PRIMARY_DARK = new Color(27, 67, 50);    // #1b4332 Dark green
    private static final Color ACCENT_ORANGE = new Color(255, 107, 53); // #ff6b35 Subtle orange
    private static final Color BG_LIGHT = new Color(250, 250, 250);
    private static final Color TEXT_MUTED = new Color(108, 117, 125);

    public static void generateInvoicePdf(Invoice invoice, OutputStream out) throws Exception {
        Document document = new Document(PageSize.A4, 36, 36, 40, 40);
        PdfWriter writer = PdfWriter.getInstance(document, out);
        document.open();

        Font brandFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, PRIMARY_DARK);
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, PRIMARY_DARK);
        Font subTitleFont = FontFactory.getFont(FontFactory.HELVETICA, 10, TEXT_MUTED);
        Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.BLACK);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK);
        Font headerCellFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font orangeFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, ACCENT_ORANGE);

        // Header Table
        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{60, 40});

        // Left cell: Restaurant details
        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.NO_BORDER);
        leftCell.addElement(new Paragraph(invoice.getRestaurantName(), brandFont));
        leftCell.addElement(new Paragraph(invoice.getRestaurantAddress(), subTitleFont));
        leftCell.addElement(new Paragraph("Digital Tax Invoice / Cash Receipt", subTitleFont));
        headerTable.addCell(leftCell);

        // Right cell: Invoice Details
        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.NO_BORDER);
        rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        Paragraph invTitle = new Paragraph("INVOICE", titleFont);
        invTitle.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(invTitle);

        Paragraph invNum = new Paragraph("# " + invoice.getInvoiceNumber(), orangeFont);
        invNum.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(invNum);

        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
        String dateStr = invoice.getInvoiceDate() != null ? sdf.format(invoice.getInvoiceDate()) : "N/A";
        Paragraph invDate = new Paragraph("Date: " + dateStr, subTitleFont);
        invDate.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(invDate);

        Paragraph ordCode = new Paragraph("Order ID: " + (invoice.getOrderCode() != null ? invoice.getOrderCode() : "N/A"), boldFont);
        ordCode.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(ordCode);

        headerTable.addCell(rightCell);
        document.add(headerTable);

        // Horizontal Line
        document.add(new Paragraph(" "));
        LineSeparator sep = new LineSeparator(1, 100, PRIMARY_DARK, Element.ALIGN_CENTER, -2);
        document.add(sep);
        document.add(new Paragraph(" "));

        // Customer & Order Info Table
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setWidths(new float[]{50, 50});

        PdfPCell custCell = new PdfPCell();
        custCell.setBackgroundColor(BG_LIGHT);
        custCell.setPadding(8);
        custCell.addElement(new Paragraph("BILLED TO:", boldFont));
        custCell.addElement(new Paragraph("Customer Name: " + invoice.getCustomerName(), normalFont));
        custCell.addElement(new Paragraph("Phone: " + invoice.getCustomerMobile(), normalFont));
        custCell.addElement(new Paragraph("Order Type: " + invoice.getOrderType().replace('_', ' '), normalFont));
        infoTable.addCell(custCell);

        PdfPCell payCell = new PdfPCell();
        payCell.setBackgroundColor(BG_LIGHT);
        payCell.setPadding(8);
        payCell.addElement(new Paragraph("PAYMENT DETAILS:", boldFont));
        payCell.addElement(new Paragraph("Payment Method: CASH ON DELIVERY (COD)", orangeFont));
        payCell.addElement(new Paragraph("Payment Status: " + invoice.getPaymentStatus(), boldFont));
        payCell.addElement(new Paragraph("Settlement: Cash to be paid to delivery / counter staff", subTitleFont));
        infoTable.addCell(payCell);

        document.add(infoTable);
        document.add(new Paragraph(" "));

        // Items Table
        PdfPTable itemTable = new PdfPTable(4);
        itemTable.setWidthPercentage(100);
        itemTable.setWidths(new float[]{50, 15, 15, 20});

        String[] headers = {"Item Description", "Unit Price", "Qty", "Total (INR)"};
        for (String h : headers) {
            PdfPCell c = new PdfPCell(new Phrase(h, headerCellFont));
            c.setBackgroundColor(PRIMARY_DARK);
            c.setPadding(6);
            if (!h.equals("Item Description")) {
                c.setHorizontalAlignment(Element.ALIGN_RIGHT);
            }
            itemTable.addCell(c);
        }

        if (invoice.getItems() != null && !invoice.getItems().isEmpty()) {
            for (OrderItem it : invoice.getItems()) {
                PdfPCell nameCell = new PdfPCell(new Phrase(it.getItemName(), normalFont));
                nameCell.setPadding(6);
                itemTable.addCell(nameCell);

                PdfPCell priceCell = new PdfPCell(new Phrase("Rs. " + it.getUnitPrice(), normalFont));
                priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                priceCell.setPadding(6);
                itemTable.addCell(priceCell);

                PdfPCell qtyCell = new PdfPCell(new Phrase(String.valueOf(it.getQuantity()), normalFont));
                qtyCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                qtyCell.setPadding(6);
                itemTable.addCell(qtyCell);

                PdfPCell subCell = new PdfPCell(new Phrase("Rs. " + it.getSubtotal(), boldFont));
                subCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                subCell.setPadding(6);
                itemTable.addCell(subCell);
            }
        }

        document.add(itemTable);

        // Totals Table
        PdfPTable totalTable = new PdfPTable(2);
        totalTable.setWidthPercentage(100);
        totalTable.setWidths(new float[]{70, 30});

        addTotalRow(totalTable, "Subtotal:", "Rs. " + invoice.getSubtotal(), normalFont, normalFont);
        addTotalRow(totalTable, "Applicable GST (5%):", "Rs. " + invoice.getGstAmount(), normalFont, normalFont);
        addTotalRow(totalTable, "Delivery Charge:", "Rs. " + invoice.getDeliveryCharge(), normalFont, normalFont);

        PdfPCell grandLabel = new PdfPCell(new Phrase("GRAND TOTAL (COD):", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, PRIMARY_DARK)));
        grandLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
        grandLabel.setPadding(8);
        grandLabel.setBorder(Rectangle.TOP);
        totalTable.addCell(grandLabel);

        PdfPCell grandVal = new PdfPCell(new Phrase("Rs. " + invoice.getGrandTotal(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, ACCENT_ORANGE)));
        grandVal.setHorizontalAlignment(Element.ALIGN_RIGHT);
        grandVal.setPadding(8);
        grandVal.setBorder(Rectangle.TOP);
        totalTable.addCell(grandVal);

        document.add(totalTable);

        // Footer note
        document.add(new Paragraph(" "));
        document.add(sep);
        Paragraph footer = new Paragraph("Thank you for ordering with Smart Restaurant System! For any inquiries, please contact the restaurant directly.", subTitleFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();
    }

    private static void addTotalRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell c1 = new PdfPCell(new Phrase(label, labelFont));
        c1.setHorizontalAlignment(Element.ALIGN_RIGHT);
        c1.setBorder(Rectangle.NO_BORDER);
        c1.setPadding(4);
        table.addCell(c1);

        PdfPCell c2 = new PdfPCell(new Phrase(value, valueFont));
        c2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        c2.setBorder(Rectangle.NO_BORDER);
        c2.setPadding(4);
        table.addCell(c2);
    }
}

