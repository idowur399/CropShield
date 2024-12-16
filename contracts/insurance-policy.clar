;; Insurance Policy Contract

(define-trait insurance-policy-trait
  (
    (create-policy (principal (string-ascii 64) uint uint) (response uint uint))
    (get-policy (uint) (response {farmer: principal, crop-type: (string-ascii 64), coverage-amount: uint, duration: uint, status: (string-ascii 20)} uint))
    (update-policy-status (uint (string-ascii 20)) (response bool uint))
  )
)

(define-map policies
  { policy-id: uint }
  {
    farmer: principal,
    crop-type: (string-ascii 64),
    coverage-amount: uint,
    duration: uint,
    status: (string-ascii 20)
  }
)

(define-data-var policy-id-nonce uint u0)

(define-read-only (get-policy (policy-id uint))
  (match (map-get? policies {policy-id: policy-id})
    policy (ok policy)
    (err u404)))

(define-public (create-policy (farmer principal) (crop-type (string-ascii 64)) (coverage-amount uint) (duration uint))
  (let
    ((policy-id (var-get policy-id-nonce)))
    (map-set policies
      {policy-id: policy-id}
      {
        farmer: farmer,
        crop-type: crop-type,
        coverage-amount: coverage-amount,
        duration: duration,
        status: "active"
      })
    (var-set policy-id-nonce (+ policy-id u1))
    (ok policy-id)))

(define-public (update-policy-status (policy-id uint) (new-status (string-ascii 20)))
  (match (map-get? policies {policy-id: policy-id})
    policy (ok (map-set policies
                {policy-id: policy-id}
                (merge policy {status: new-status})))
    (err u404)))

