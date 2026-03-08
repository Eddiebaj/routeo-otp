FROM opentripplanner/opentripplanner:2.5.0

USER root

# Force cache bust + find everything
RUN echo "cache-bust-3" && \
    echo "=== ALL FILES IN / (2 levels) ===" && ls -la / && \
    echo "=== /app ===" && ls -laR /app 2>/dev/null; \
    echo "=== /opt ===" && ls -laR /opt 2>/dev/null; \
    echo "=== /usr/local/bin ===" && ls -la /usr/local/bin 2>/dev/null; \
    echo "=== /usr/bin ===" && ls -la /usr/bin | grep -i otp 2>/dev/null; \
    echo "=== ENTRYPOINT ===" && cat /proc/1/cmdline 2>/dev/null; \
    echo "=== find jars ===" && find / -name "*.jar" 2>/dev/null; \
    echo "DONE"

EXPOSE 8080
