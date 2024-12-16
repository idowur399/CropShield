;; Weather Oracle Contract

(define-trait weather-oracle-trait
  (
    (register-policy (uint) (response bool uint))
    (update-weather-data (uint (list 10 {temperature: int, rainfall: uint})) (response bool uint))
    (get-weather-data (uint) (response (list 10 {temperature: int, rainfall: uint}) uint))
  )
)

(define-map weather-data
  { policy-id: uint }
  { data: (list 10 {temperature: int, rainfall: uint}) }
)

(define-public (register-policy (policy-id uint))
  (begin
    (map-set weather-data
      {policy-id: policy-id}
      {data: (list)})
    (ok true)))

(define-public (update-weather-data (policy-id uint) (new-data (list 10 {temperature: int, rainfall: uint})))
  (begin
    (map-set weather-data
      {policy-id: policy-id}
      {data: new-data})
    (ok true)))

(define-read-only (get-weather-data (policy-id uint))
  (match (map-get? weather-data {policy-id: policy-id})
    weather-info (ok (get data weather-info))
    (err u404)))

