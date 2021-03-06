# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import goland with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

goland-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/goland
      - {{ goland.dir.path }}

        {% if goland.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

goland-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: golandhome
    - path: {{ goland.dir.path }}
    - onlyif: update-alternatives --get-selections |grep ^golandhome


goland-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: goland
    - path: {{ goland.dir.path }}/{{ goland.command }}
    - onlyif: update-alternatives --get-selections |grep ^goland

        {%- else %}

goland-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (goland.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
