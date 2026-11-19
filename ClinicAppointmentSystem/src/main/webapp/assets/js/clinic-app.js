/**
 * Frontend JavaScript for Clinic Appointment Scheduling System
 * Developer: Hemalatha Ganji (Roll No: 24761A05S2)
 */

document.addEventListener('DOMContentLoaded', function () {
    // Restrict date inputs from selecting past dates
    const dateInputs = document.querySelectorAll('input[type="date"]');
    const today = new Date().toISOString().split('T')[0];
    dateInputs.forEach(input => {
        if (!input.hasAttribute('data-allow-past')) {
            input.setAttribute('min', today);
        }
    });

    // Time Slot Pills selection handler
    const slotButtons = document.querySelectorAll('.slot-pill-btn');
    const slotHiddenInput = document.getElementById('selectedTimeSlot');
    slotButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            slotButtons.forEach(b => b.classList.remove('active', 'btn-primary'));
            slotButtons.forEach(b => b.classList.add('btn-outline-primary'));
            this.classList.remove('btn-outline-primary');
            this.classList.add('active', 'btn-primary');
            if (slotHiddenInput) {
                slotHiddenInput.value = this.getAttribute('data-slot');
            }
        });
    });

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 6000);
    });
});

function confirmCancelAction(form) {
    if (confirm("Are you sure you want to cancel this appointment schedule? This will release the doctor slot.")) {
        form.submit();
    }
    return false;
}
