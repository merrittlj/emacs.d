(require 'autothemer)

(autothemer-deftheme
 st "A theme based on my st configuration"

 ((((class color) (min-colors #xFFFFFF)))  ;; only use in graphical Emacs

  ;; define our color palette
  (st-grey "#bab5a1")
  (st-orange "#ce664d")
  (st-dark-grey "#898776")
  (st-brown "#877861")
  (st-dark-brown "#454138")
  (st-indigo "#2a0d83")
  (st-second-grey "#7a766f")
  (st-light-yellow "#ece2b1")
  (st-gold "#af5f00")
  )

 ;; customize faces
 ((default (:foreground st-dark-brown :background st-grey))
  (cursor (:background st-dark-brown))
  (font-lock-preprocessor-face (:foreground st-dark-brown))
  (font-lock-string-face (:foreground st-orange))
  (font-lock-type-face (:foreground st-dark-brown))
  (font-lock-function-name-face (:foreground st-dark-brown))
  (font-lock-keyword-face (:foreground st-gold))
  (font-lock-variable-name-face (:foreground st-dark-brown))
  (font-lock-constant-face (:foreground st-orange))
  (font-lock-comment-face (:foreground st-second-grey))
  (mode-line (:foreground st-grey :background st-dark-brown))
  (mode-line-inactive (:foreground st-dark-brown :background st-second-grey))
  (fringe (:background st-grey))
  (help-key-binding (:foreground st-grey :background st-dark-brown))
  (region (:foreground st-grey :background st-dark-brown))
  ))

(provide-theme 'st)

