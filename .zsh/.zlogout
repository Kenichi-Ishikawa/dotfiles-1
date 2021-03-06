#******************************************************************************
#
#  .zlogout
#
#  (in $ZDOTDIR : default $HOME)
#
#  finalize setup file for only interactive zsh when you log out
#  Not read in for subsequent shells.
#
#******************************************************************************

# Logout message.
# If <<- is used instead of <<,
# then all leading tabs are stripped from word and from the document.
cat <<-EOF

Don't forget.
Always, somewhere,
someone is fighting for you.
-- As long as you remember her,
you are not alone.
EOF

