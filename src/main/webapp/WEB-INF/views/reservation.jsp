<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Book a Table - Smart Restaurant" />
<c:set var="activePage" value="reservation" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Notifications -->
                <c:if test="${param.bookingSuccess == 'true'}">
                    <div class="alert alert-success alert-dismissible fade show rounded-4 p-4 shadow-sm mb-4" role="alert">
                        <div class="d-flex align-items-center gap-3">
                            <i class="bi bi-check-circle-fill display-5 text-success"></i>
                            <div>
                                <h5 class="fw-bold mb-1">Table Reservation Confirmed!</h5>
                                <p class="mb-0 small text-secondary">
                                    Your reservation (Ref #${param.resId}) has been successfully submitted to the restaurant. You may pay in cash at the venue.
                                </p>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.error == 'slot_unavailable'}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Sorry, the selected table was just booked by another customer. Please choose another table or time slot.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Booking Card -->
                <div class="card border-0 rounded-4 shadow-sm overflow-hidden">
                    <div class="card-header p-4 text-white" style="background: linear-gradient(135deg, var(--primary-dark), #2d6a4f);">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle p-3 bg-white bg-opacity-25 fs-3">
                                <i class="bi bi-calendar2-heart"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold mb-1">Reserve a Dining Table</h3>
                                <p class="mb-0 text-white-50 small">
                                    Guaranteed seating with live database table checks and zero upfront reservation fees.
                                </p>
                            </div>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/reserve-table" method="POST" class="p-4 p-md-5">
                        <div class="row g-4">
                            <!-- Restaurant Selection -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Select Restaurant <span class="text-danger">*</span></label>
                                <select name="restaurantId" id="resRestaurantSelect" class="form-select py-2" required>
                                    <c:forEach var="rest" items="${restaurants}">
                                        <option value="${rest.restaurantId}" ${selectedRestaurant.restaurantId == rest.restaurantId ? 'selected' : ''}>
                                            ${rest.name} (${rest.primaryArea} - ${rest.cuisine})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Date Picker -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Reservation Date <span class="text-danger">*</span></label>
                                <input type="date" name="reservationDate" id="resDateInput" class="form-control py-2" 
                                       value="${todayDate}" min="${todayDate}" required>
                            </div>

                            <!-- Time Slot -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Dining Time Slot <span class="text-danger">*</span></label>
                                <select name="timeSlot" id="resSlotSelect" class="form-select py-2" required>
                                    <option value="12:00 PM - 01:30 PM">Lunch: 12:00 PM - 01:30 PM</option>
                                    <option value="01:30 PM - 03:00 PM">Lunch: 01:30 PM - 03:00 PM</option>
                                    <option value="07:00 PM - 08:30 PM">Dinner: 07:00 PM - 08:30 PM</option>
                                    <option value="08:30 PM - 10:00 PM" selected>Dinner: 08:30 PM - 10:00 PM</option>
                                    <option value="10:00 PM - 11:00 PM">Late Dinner: 10:00 PM - 11:00 PM</option>
                                </select>
                            </div>

                            <!-- Number of Guests -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Number of Guests <span class="text-danger">*</span></label>
                                <input type="number" name="guestCount" id="resGuestInput" class="form-control py-2" 
                                       value="2" min="1" max="16" required>
                            </div>

                            <!-- Available Tables Dropdown (Dynamic from MySQL) -->
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-secondary d-flex justify-content-between align-items-center">
                                    <span>Select Available Table <span class="text-danger">*</span></span>
                                    <span class="badge bg-success-subtle text-success small"><i class="bi bi-shield-check me-1"></i>Real-time MySQL Checked</span>
                                </label>
                                <select name="tableId" id="resTableSelect" class="form-select py-2" required>
                                    <c:forEach var="tbl" items="${availableTables}">
                                        <option value="${tbl.tableId}">
                                            ${tbl.tableNumber} (Capacity: ${tbl.capacity} guests)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text small">Only tables with sufficient capacity and no conflicting bookings are displayed.</div>
                            </div>

                            <!-- Customer Information (No Login Required) -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Customer Name <span class="text-danger">*</span></label>
                                <input type="text" name="customerName" class="form-control py-2" 
                                       placeholder="e.g. Bhavani" value="${customerName}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Customer Mobile Number <span class="text-danger">*</span></label>
                                <input type="tel" name="customerMobile" class="form-control py-2" 
                                       placeholder="10-digit Mobile No." pattern="[0-9]{10}" maxlength="10" required>
                            </div>

                            <!-- Special Requests -->
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-secondary">Special Seating Requests (Optional)</label>
                                <input type="text" name="specialRequests" class="form-control py-2" 
                                       placeholder="e.g. Window side preferred, high chair needed, celebrating anniversary">
                            </div>

                            <!-- Submit Button -->
                            <div class="col-12 text-center pt-3">
                                <button type="submit" id="resSubmitBtn" class="btn btn-accent px-5 py-3 fw-bold fs-6">
                                    <i class="bi bi-calendar2-check me-1"></i> Confirm Table Reservation
                                </button>
                                <div class="text-muted small mt-2">
                                    No advance payment required. Food and beverages can be paid in cash at the counter.
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

