
class CurlRPC {

public:
    CurlRPC(void);
    ~CurlRPC(void);

private:
    CURL *curl;
};

CurlRPC::CurlRPC(void) {
    curl = curl_easy_init();
}