<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Patient Portal - Book Doctor Appointment" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main class="py-4">
    <div class="container">
        <!-- WELCOME BANNER -->
        <div class="card clinic-card border-0 mb-4 text-white overflow-hidden" 
             style="background: linear-gradient(135deg, #0284c7 0%, #0d9488 100%);">
            <div class="card-body p-4 p-md-5">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <span class="badge bg-white text-primary px-3 py-1 rounded-pill fw-bold mb-2 shadow-sm">
                            <i class="bi bi-hospital text-danger me-1"></i> Patient Outpatient Portal
                        </span>
                        <h2 class="fw-bold mb-1">Welcome, ${sessionScope.patient.patientName}!</h2>
                        <p class="text-white-50 mb-3">
                            Patient ID: <strong>${sessionScope.patient.patientId}</strong> | Blood Group: <strong>${sessionScope.patient.bloodGroup}</strong> | Phone: <strong>${sessionScope.patient.phone}</strong>
                        </p>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="#bookingSection" class="btn btn-warning btn-sm px-3 py-2 rounded-pill fw-bold text-dark">
                                <i class="bi bi-calendar-plus me-1"></i> Book New Appointment
                            </a>
                            <a href="${pageContext.request.contextPath}/myAppointments" class="btn btn-outline-light btn-sm px-3 py-2 rounded-pill fw-semibold">
                                <i class="bi bi-card-checklist me-1"></i> View My Appointments &amp; Slips
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 text-center text-lg-end d-none d-lg-block">
                        <i class="bi bi-shield-plus text-white-50" style="font-size: 6rem;"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- ERROR / FEEDBACK ALERTS -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-octagon-fill fs-5 me-2"></i>
                <strong>Booking Notice:</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error and param.error eq 'conflict'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i>
                <strong>Slot Already Reserved:</strong> The requested doctor is already booked for this date and time slot. Please choose another slot.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- DOCTOR DIRECTORY -->
            <div class="col-lg-7">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold text-dark mb-0">
                        <i class="bi bi-people-fill text-primary me-2"></i>Available Specialist Doctors
                    </h4>
                    <span class="badge bg-primary rounded-pill px-3 py-2">${doctors.size()} Specialists</span>
                </div>

                <div class="row g-3">
                    <c:forEach var="doc" items="${doctors}">
                        <div class="col-md-6">
                            <div class="card clinic-card h-100 p-3">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h6 class="fw-bold text-primary mb-1">${doc.doctorName}</h6>
                                        <span class="badge bg-info bg-opacity-25 text-primary small">${doc.specialization}</span>
                                    </div>
                                    <span class="badge bg-light text-muted border">${doc.roomNumber}</span>
                                </div>
                                <p class="small text-muted mb-2">${doc.qualification} (${doc.experienceYears}+ yrs exp)</p>
                                <div class="bg-light p-2 rounded small mb-3">
                                    <div><i class="bi bi-clock text-secondary me-1"></i> ${doc.availableHours}</div>
                                    <div><i class="bi bi-calendar3 text-secondary me-1"></i> ${doc.availableDays}</div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top">
                                    <span class="fw-bold text-success">₹${doc.consultationFee} <small class="text-muted fw-normal">fee</small></span>
                                    <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3"
                                            onclick="selectDoctor('${doc.doctorId}', '${doc.doctorName}', '${doc.specialization}')">
                                        <i class="bi bi-calendar-check me-1"></i> Book Slot
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- APPOINTMENT BOOKING FORM -->
            <div class="col-lg-5" id="bookingSection">
                <div class="card clinic-card shadow border-0 sticky-top" style="top: 80px;">
                    <div class="card-header bg-primary text-white p-3">
                        <h5 class="fw-bold mb-0">
                            <i class="bi bi-calendar2-check-fill me-2"></i>Schedule Appointment
                        </h5>
                        <small class="text-white-50">Initial status will be marked as <strong>Pending</strong></small>
                    </div>

                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/bookAppointment" method="post" id="appointmentForm">
                            <!-- Selected Doctor -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Consulting Doctor <span class="text-danger">*</span></label>
                                <select name="doctorId" id="doctorSelect" class="form-select" required>
                                    <option value="" disabled selected>-- Choose Medical Specialist --</option>
                                    <c:forEach var="doc" items="${doctors}">
                                        <option value="${doc.doctorId}">
                                            ${doc.doctorName} - ${doc.specialization} (${doc.roomNumber})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Appointment Date -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Consultation Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-calendar-event text-primary"></i></span>
                                    <input type="date" name="appointmentDate" id="appointmentDate" class="form-control" required>
                                </div>
                                <small class="text-muted">Must be today or a future date</small>
                            </div>

                            <!-- Time Slot Selection -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Preferred Time Slot <span class="text-danger">*</span></label>
                                <input type="hidden" name="timeSlot" id="selectedTimeSlot" value="09:30 AM - 10:00 AM">
                                
                                <div class="d-flex flex-wrap gap-2 mb-2">
                                    <button type="button" class="btn btn-primary btn-sm slot-pill-btn active" data-slot="09:30 AM - 10:00 AM">09:30 AM</button>
                                    <button type="button" class="btn btn-outline-primary btn-sm slot-pill-btn" data-slot="10:00 AM - 10:30 AM">10:00 AM</button>
                                    <button type="button" class="btn btn-outline-primary btn-sm slot-pill-btn" data-slot="10:30 AM - 11:00 AM">10:30 AM</button>
                                    <button type="button" class="btn btn-outline-primary btn-sm slot-pill-btn" data-slot="11:30 AM - 12:00 PM">11:30 AM</button>
                                    <button type="button" class="btn btn-outline-primary btn-sm slot-pill-btn" data-slot="02:30 PM - 03:00 PM">02:30 PM</button>
                                    <button type="button" class="btn btn-outline-primary btn-sm slot-pill-btn" data-slot="03:30 PM - 04:00 PM">03:30 PM</button>
                                    <button type="button" class="btn btn-outline-primary btn-sm slot-pill-btn" data-slot="04:30 PM - 05:00 PM">04:30 PM</button>
                                </div>
                                <small class="text-muted">Selected Slot: <strong id="slotLabel" class="text-primary">09:30 AM - 10:00 AM</strong></small>
                            </div>

                            <!-- Reason for Visit -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Reason for Visit / Symptoms <span class="text-danger">*</span></label>
                                <textarea name="reason" class="form-control" rows="2" placeholder="e.g. Chest pain review, routine diabetes checkup, skin rash..." required></textarea>
                            </div>

                            <!-- Additional Notes -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Additional Patient Notes <small class="text-muted">(Optional)</small></label>
                                <input type="text" name="notes" class="form-control" placeholder="e.g. Follow-up consultation, bringing previous lab reports">
                            </div>

                            <button type="submit" class="btn btn-clinic w-100 py-2 fw-bold">
                                <i class="bi bi-check2-circle me-1"></i> Confirm Appointment Request
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function selectDoctor(id, name, spec) {
    const sel = document.getElementById('doctorSelect');
    if (sel) {
        sel.value = id;
        document.getElementById('bookingSection').scrollIntoView({ behavior: 'smooth' });
    }
}

document.addEventListener('DOMContentLoaded', function () {
    const slotButtons = document.querySelectorAll('.slot-pill-btn');
    const slotHiddenInput = document.getElementById('selectedTimeSlot');
    const slotLabel = document.getElementById('slotLabel');

    slotButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            slotButtons.forEach(b => {
                b.classList.remove('active', 'btn-primary');
                b.classList.add('btn-outline-primary');
            });
            this.classList.remove('btn-outline-primary');
            this.classList.add('active', 'btn-primary');
            const slotVal = this.getAttribute('data-slot');
            if (slotHiddenInput) slotHiddenInput.value = slotVal;
            if (slotLabel) slotLabel.textContent = slotVal;
        });
    });
});
</script>

<%@ include file="common/footer.jsp" %>
