� �
 V+�+Ɋ��0;sF�&�r��t�Z;��<'t<"uF�Ā<t�:�u8t��F���<^uF�,@< s�����<@u!9>s�>F��= s��tH��������t
= r�ê�í%�߆�=RCu�� =FLu�
�=FFu��=SEu�$�<Cu�����ÿ�� D+��!�u��� �  �?�!s�^ ����uO�>��)�� �+����� �< t�<;t�<,t�N�</?u
�E�	�!�" <t��s�E;>s�>����)ѻ �@�!��L�!QECHO 1.3 (c) 1999 Horst Schaeffer
Echo strings and special characters (to STDOUT)
defaults without terminating carriage return + line feed
Specify..
� strings in single or double quote marks
  to use the same type of quote marks within a string: double
  e.g. "The word is ""FOO"""
� byte values (decimal)
� control characters with caret, e.g.: ^G
� special characters: CR,LF,FF,ESC
Separators: blank space and/or comma
Examples:
  QECHO "a string with " ^G "bell",CR,LF
  QECHO "<A HREF=""%URL%"">Description</A>" >> some.htm
Extras:
  @n sets writing point to column n
  Input line (STDIN) is taken for modifications

$