<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Invoice ${invoice.invoiceNumber} - Smart Restaurant" />
<jsp:include page="common/header.jsp" />

<main class="py-5 bg-light">
    <div class="container">
        <!-- Print & Download Control Bar -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 no-print">
            <a href="${pageContext.request.contextPath}/track-order?orderCode=${invoice.orderCode}&mobile=${invoice.customerMobile}" class="btn btn-outline-dark btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Back to Tracking
            </a>
            <div class="d-flex gap-2">
                <button type="button" onclick="window.print();" class="btn btn-outline-primary btn-sm px-3">
                    <i class="bi bi-printer me-1"></i> Print Invoice
                </button>
                <a href="${pageContext.request.contextPath}/invoice/pdf?num=${invoice.invoiceNumber}" class="btn btn-accent btn-sm px-3">
                    <i class="bi bi-file-earmark-pdf me-1"></i> Download PDF
                </a>
            </div>
        </div>

        <!-- Professional Invoice Container -->
        <div class="invoice-container mx-auto" style="max-width: 820px;">
            <!-- Invoice Header -->
            <div class="d-flex justify-content-between align-items-start border-bottom pb-4 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <i class="bi bi-fire text-warning fs-2"></i>
                        <h3 class="fw-bold mb-0 text-dark">${invoice.restaurantName}</h3>
                    </div>
                    <div class="text-secondary small">${invoice.restaurantAddress}</div>
                    <div class="badge bg-dark text-light mt-2">Digital Tax Invoice / Cash Voucher</div>
                </div>
                <div class="text-end">
                    <h4 class="fw-bold mb-0" style="color: var(--accent-orange);">INVOICE</h4>
                    <div class="fw-bold text-dark fs-6"># ${invoice.invoiceNumber}</div>
                    <div class="text-muted small mt-1">
                        Date: <fmt:formatDate value="${invoice.invoiceDate}" pattern="dd-MMM-yyyy hh:mm a" />
                    </div>
                    <div class="small fw-semibold text-secondary">
                        Order ID: <strong>${invoice.orderCode}</strong>
                    </div>
                </div>
            </div>

            <!-- Customer & Payment Details -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6">
                    <div class="p-3 bg-light rounded-3 border h-100">
                        <div class="text-uppercase small fw-bold text-muted mb-2">Billed To</div>
                        <h6 class="fw-bold mb-1 text-dark">${invoice.customerName}</h6>
                        <div class="small text-secondary"><i class="bi bi-telephone me-1"></i>${invoice.customerMobile}</div>
                        <div class="small text-secondary"><i class="bi bi-tag me-1"></i>Order Type: <strong class="text-dark">${invoice.orderType}</strong></div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="p-3 bg-light rounded-3 border h-100">
                        <div class="text-uppercase small fw-bold text-muted mb-2">Payment Terms</div>
                        <div class="small text-secondary mb-1">Method: <strong class="text-dark">CASH ON DELIVERY (COD)</strong></div>
                        <div class="small text-secondary mb-1">
                            Status: 
                            <span class="badge ${invoice.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'}">
                                ${invoice.paymentStatus}
                            </span>
                        </div>
                        <div class="small text-muted mt-2">
                            Cash collected upon delivery or counter service.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Items Table -->
            <div class="table-responsive mb-4">
                <table class="table align-middle">
                    <thead style="background-color: var(--primary-dark); color: #ffffff;">
                        <tr class="small text-uppercase">
                            <th class="ps-3 py-2">Item Description</th>
                            <th class="text-end py-2">Unit Price</th>
                            <th class="text-center py-2">Qty</th>
                            <th class="text-end pe-3 py-2">Total Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${invoice.items}">
                            <tr>
                                <td class="ps-3 fw-semibold text-dark">${item.itemName}</td>
                                <td class="text-end">Rs. ${item.unitPrice}</td>
                                <td class="text-center">${item.quantity}</td>
                                <td class="text-end pe-3 fw-bold text-dark">Rs. ${item.subtotal}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Calculation Breakdown -->
            <div class="row justify-content-end mb-4">
                <div class="col-sm-6 col-md-5">
                    <div class="d-flex justify-content-between py-1 small text-secondary">
                        <span>Item Subtotal:</span>
                        <span class="fw-semibold text-dark">Rs. ${invoice.subtotal}</span>
                    </div>
                    <div class="d-flex justify-content-between py-1 small text-secondary">
                        <span>Applicable GST (5%):</span>
                        <span class="fw-semibold text-dark">Rs. ${invoice.gstAmount}</span>
                    </div>
                    <div class="d-flex justify-content-between py-1 small text-secondary">
                        <span>Delivery Charges:</span>
                        <span class="fw-semibold text-dark">Rs. ${invoice.deliveryCharge}</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-top border-bottom my-2 fs-5 fw-bold" style="color: var(--primary-dark);">
                        <span>Grand Total (COD):</span>
                        <span style="color: var(--accent-orange);">Rs. ${invoice.grandTotal}</span>
                    </div>
                </div>
            </div>

            <!-- Footer Note -->
            <div class="border-top pt-3 text-center text-muted small">
                <div>Thank you for choosing ${invoice.restaurantName}! This is a computer-generated tax invoice.</div>
                <div>Smart Restaurant Ordering & Billing System &bull; COD Receipt</div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

