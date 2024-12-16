;; Premium Payment Contract

(define-trait premium-payment-trait
  (
    (process-payment (principal uint) (response bool uint))
    (process-refund (principal uint) (response bool uint))
  )
)

(define-map payments
  { payment-id: uint }
  {
    payer: principal,
    amount: uint,
    timestamp: uint
  }
)

(define-data-var payment-id-nonce uint u0)

(define-public (process-payment (payer principal) (amount uint))
  (let
    ((payment-id (var-get payment-id-nonce)))
    (try! (stx-transfer? amount payer (as-contract tx-sender)))
    (map-set payments
      {payment-id: payment-id}
      {
        payer: payer,
        amount: amount,
        timestamp: block-height
      })
    (var-set payment-id-nonce (+ payment-id u1))
    (ok true)))

(define-public (process-refund (recipient principal) (amount uint))
  (let
    ((contract-balance (stx-get-balance (as-contract tx-sender))))
    (asserts! (<= amount contract-balance) (err u401))
    (try! (as-contract (stx-transfer? amount tx-sender recipient)))
    (ok true)))

