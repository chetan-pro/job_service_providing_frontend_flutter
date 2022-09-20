function checkout(optionsStr) {
    var options = JSON.parse(optionsStr);
    options.handler = function(response) {
        window.parent.postMessage("SUCCESS", response); //2 
    }
    var rzp1 = new Razorpay(options);
    rzp1.on('payment.failed', function(response) {
        console.log("response fail ");
        console.log(response);
        window.sessionStorage.setItem('razorpayStatus', 'FAILED');
    });
    rzp1.on('payment.submit', function(response) {
        console.log("response submit");
        console.log(response);
        console.log("kalim");
        window.sessionStorage.setItem('submit', response);
    });
    rzp1.on('payment.error', function(response) {
        console.log("response success");
        console.log(response);
        window.sessionStorage.setItem('razorpayStatus', response);
    });
    rzp1.open();
}