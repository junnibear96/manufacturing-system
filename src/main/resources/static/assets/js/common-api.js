/**
 * Common API Utility
 * Standardizes AJAX requests across the application using jQuery.
 */
const Api = {
    /**
     * General request method
     * @param {string} url - Request URL
     * @param {string} method - HTTP Method (GET, POST, PUT, DELETE)
     * @param {object} data - Data to send (optional)
     * @param {function} successCallback - Function to call on success
     * @param {function} errorCallback - Function to call on error
     */
    request: function (url, method, data, successCallback, errorCallback) {
        $.ajax({
            url: url,
            type: method,
            data: data ? JSON.stringify(data) : null,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (successCallback) successCallback(response);
            },
            error: function (xhr, status, error) {
                console.error("API Error:", status, error);
                if (errorCallback) {
                    errorCallback(xhr, status, error);
                } else {
                    alert("시스템 오류가 발생했습니다. 관리자에게 문의해주세요.");
                }
            }
        });
    },

    /**
     * GET request
     */
    get: function (url, successCallback, errorCallback) {
        this.request(url, "GET", null, successCallback, errorCallback);
    },

    /**
     * POST request
     */
    post: function (url, data, successCallback, errorCallback) {
        this.request(url, "POST", data, successCallback, errorCallback);
    }
};
