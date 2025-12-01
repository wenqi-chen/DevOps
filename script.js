// script.js

// 1. Wait for the DOM content to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log("Dashboard JS loaded successfully!");

    // 2. Get the canvas context by its ID
    const ctx = document.getElementById('revenueChart');

    // 3. Check if the element exists and initialize the chart
    if (ctx) {
        new Chart(ctx, {
            type: 'line', // You can change this to 'bar', 'pie', etc.
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Monthly Revenue (€)',
                    data: [12000, 19000, 30000, 18000, 25000, 35000],
                    borderColor: 'rgba(0, 123, 255, 1)', // Bootstrap primary color
                    backgroundColor: 'rgba(0, 123, 255, 0.2)',
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, // Allows the chart to fit the card height
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    // Example of a simple interactive script:
    const salesCard = document.querySelector('.card.text-bg-primary');
    salesCard.addEventListener('click', () => {
        alert('Displaying detailed sales report...');
    });
});