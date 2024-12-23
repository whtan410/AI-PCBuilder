PGDMP      ;            
    |            moonarch    16.3    16.3 A               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    57830    moonarch    DATABASE     }   CREATE DATABASE moonarch WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Malaysia.932';
    DROP DATABASE moonarch;
                postgres    false            �            1259    90645 
   cart_items    TABLE     H  CREATE TABLE public.cart_items (
    cart_item_id integer NOT NULL,
    user_id uuid NOT NULL,
    product_id integer,
    build_id integer,
    quantity integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT cart_items_check CHECK ((NOT ((product_id IS NOT NULL) AND (build_id IS NOT NULL))))
);
    DROP TABLE public.cart_items;
       public         heap    postgres    false            �            1259    90644    cart_items_cart_item_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_items_cart_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.cart_items_cart_item_id_seq;
       public          postgres    false    227                       0    0    cart_items_cart_item_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.cart_items_cart_item_id_seq OWNED BY public.cart_items.cart_item_id;
          public          postgres    false    226            �            1259    66035 	   feedbacks    TABLE     �   CREATE TABLE public.feedbacks (
    order_id uuid NOT NULL,
    rating integer NOT NULL,
    platform character varying(255) NOT NULL,
    CONSTRAINT feedbacks_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);
    DROP TABLE public.feedbacks;
       public         heap    postgres    false            �            1259    90688    order_delivery_info    TABLE     +  CREATE TABLE public.order_delivery_info (
    order_id uuid NOT NULL,
    street_address character varying(255) NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    postcode character varying(20) NOT NULL,
    country character varying(100) NOT NULL
);
 '   DROP TABLE public.order_delivery_info;
       public         heap    postgres    false            �            1259    57854    order_details    TABLE     �   CREATE TABLE public.order_details (
    order_id uuid NOT NULL,
    order_time timestamp without time zone NOT NULL,
    order_status character varying(50) NOT NULL,
    user_id uuid NOT NULL
);
 !   DROP TABLE public.order_details;
       public         heap    postgres    false            �            1259    57864    order_items    TABLE     �   CREATE TABLE public.order_items (
    order_id uuid NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL
);
    DROP TABLE public.order_items;
       public         heap    postgres    false            �            1259    90700    order_payment_info    TABLE       CREATE TABLE public.order_payment_info (
    order_id uuid NOT NULL,
    payment_method character varying(50) NOT NULL,
    payment_reference character varying(100) NOT NULL,
    payment_status character varying(50) NOT NULL,
    payment_time timestamp without time zone NOT NULL
);
 &   DROP TABLE public.order_payment_info;
       public         heap    postgres    false            �            1259    74229    prebuilt    TABLE       CREATE TABLE public.prebuilt (
    build_id integer NOT NULL,
    build_name character varying(255) NOT NULL,
    build_parts jsonb,
    build_img_url character varying(255),
    build_cost numeric(10,2),
    build_price numeric(10,2),
    build_stock_count integer
);
    DROP TABLE public.prebuilt;
       public         heap    postgres    false            �            1259    74228    prebuilt_build_id_seq    SEQUENCE     �   CREATE SEQUENCE public.prebuilt_build_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.prebuilt_build_id_seq;
       public          postgres    false    224                       0    0    prebuilt_build_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.prebuilt_build_id_seq OWNED BY public.prebuilt.build_id;
          public          postgres    false    223            �            1259    82467    prebuilt_order_items    TABLE     �   CREATE TABLE public.prebuilt_order_items (
    order_id uuid NOT NULL,
    build_id integer NOT NULL,
    quantity integer NOT NULL
);
 (   DROP TABLE public.prebuilt_order_items;
       public         heap    postgres    false            �            1259    57832    products    TABLE     \  CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    brand character varying(100) NOT NULL,
    category character varying(100) NOT NULL,
    cost numeric(10,2) NOT NULL,
    sales_price numeric(10,2) NOT NULL,
    stock_count integer NOT NULL,
    img_url character varying(255)
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    57831    products_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_product_id_seq;
       public          postgres    false    216                       0    0    products_product_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;
          public          postgres    false    215            �            1259    57848    traffics    TABLE     �   CREATE TABLE public.traffics (
    traffic_id integer NOT NULL,
    visit_date date NOT NULL,
    number_of_visits integer NOT NULL
);
    DROP TABLE public.traffics;
       public         heap    postgres    false            �            1259    57847    traffics_traffic_id_seq    SEQUENCE     �   CREATE SEQUENCE public.traffics_traffic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.traffics_traffic_id_seq;
       public          postgres    false    219                       0    0    traffics_traffic_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.traffics_traffic_id_seq OWNED BY public.traffics.traffic_id;
          public          postgres    false    218            �            1259    57838    users    TABLE     �  CREATE TABLE public.users (
    user_id uuid NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    full_name character varying(255),
    phone_number character varying(20),
    user_type character varying(50) DEFAULT 'customer'::character varying NOT NULL,
    street_address text,
    city character varying(100),
    state character varying(100),
    postcode character varying(5),
    country character varying(100) DEFAULT 'Malaysia'::character varying
);
    DROP TABLE public.users;
       public         heap    postgres    false            J           2604    90648    cart_items cart_item_id    DEFAULT     �   ALTER TABLE ONLY public.cart_items ALTER COLUMN cart_item_id SET DEFAULT nextval('public.cart_items_cart_item_id_seq'::regclass);
 F   ALTER TABLE public.cart_items ALTER COLUMN cart_item_id DROP DEFAULT;
       public          postgres    false    227    226    227            I           2604    74232    prebuilt build_id    DEFAULT     v   ALTER TABLE ONLY public.prebuilt ALTER COLUMN build_id SET DEFAULT nextval('public.prebuilt_build_id_seq'::regclass);
 @   ALTER TABLE public.prebuilt ALTER COLUMN build_id DROP DEFAULT;
       public          postgres    false    223    224    224            E           2604    57835    products product_id    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    215    216    216            H           2604    57851    traffics traffic_id    DEFAULT     z   ALTER TABLE ONLY public.traffics ALTER COLUMN traffic_id SET DEFAULT nextval('public.traffics_traffic_id_seq'::regclass);
 B   ALTER TABLE public.traffics ALTER COLUMN traffic_id DROP DEFAULT;
       public          postgres    false    219    218    219                      0    90645 
   cart_items 
   TABLE DATA           g   COPY public.cart_items (cart_item_id, user_id, product_id, build_id, quantity, created_at) FROM stdin;
    public          postgres    false    227   U                 0    66035 	   feedbacks 
   TABLE DATA           ?   COPY public.feedbacks (order_id, rating, platform) FROM stdin;
    public          postgres    false    222   �U                 0    90688    order_delivery_info 
   TABLE DATA           g   COPY public.order_delivery_info (order_id, street_address, city, state, postcode, country) FROM stdin;
    public          postgres    false    228   �V                 0    57854    order_details 
   TABLE DATA           T   COPY public.order_details (order_id, order_time, order_status, user_id) FROM stdin;
    public          postgres    false    220   SW                 0    57864    order_items 
   TABLE DATA           E   COPY public.order_items (order_id, product_id, quantity) FROM stdin;
    public          postgres    false    221   QY                 0    90700    order_payment_info 
   TABLE DATA           w   COPY public.order_payment_info (order_id, payment_method, payment_reference, payment_status, payment_time) FROM stdin;
    public          postgres    false    229   �[                 0    74229    prebuilt 
   TABLE DATA           �   COPY public.prebuilt (build_id, build_name, build_parts, build_img_url, build_cost, build_price, build_stock_count) FROM stdin;
    public          postgres    false    224   
\       	          0    82467    prebuilt_order_items 
   TABLE DATA           L   COPY public.prebuilt_order_items (order_id, build_id, quantity) FROM stdin;
    public          postgres    false    225   _i                  0    57832    products 
   TABLE DATA           v   COPY public.products (product_id, product_name, brand, category, cost, sales_price, stock_count, img_url) FROM stdin;
    public          postgres    false    216   �i                 0    57848    traffics 
   TABLE DATA           L   COPY public.traffics (traffic_id, visit_date, number_of_visits) FROM stdin;
    public          postgres    false    219   �~                 0    57838    users 
   TABLE DATA           �   COPY public.users (user_id, email, password, full_name, phone_number, user_type, street_address, city, state, postcode, country) FROM stdin;
    public          postgres    false    217   �                  0    0    cart_items_cart_item_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.cart_items_cart_item_id_seq', 32, true);
          public          postgres    false    226                       0    0    prebuilt_build_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.prebuilt_build_id_seq', 1, false);
          public          postgres    false    223                       0    0    products_product_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.products_product_id_seq', 400, true);
          public          postgres    false    215                       0    0    traffics_traffic_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.traffics_traffic_id_seq', 1, false);
          public          postgres    false    218            `           2606    90651    cart_items cart_items_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (cart_item_id);
 D   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_pkey;
       public            postgres    false    227            Z           2606    66040    feedbacks feedbacks_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (order_id);
 B   ALTER TABLE ONLY public.feedbacks DROP CONSTRAINT feedbacks_pkey;
       public            postgres    false    222            b           2606    90694 ,   order_delivery_info order_delivery_info_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.order_delivery_info
    ADD CONSTRAINT order_delivery_info_pkey PRIMARY KEY (order_id);
 V   ALTER TABLE ONLY public.order_delivery_info DROP CONSTRAINT order_delivery_info_pkey;
       public            postgres    false    228            V           2606    57858     order_details order_details_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.order_details
    ADD CONSTRAINT order_details_pkey PRIMARY KEY (order_id);
 J   ALTER TABLE ONLY public.order_details DROP CONSTRAINT order_details_pkey;
       public            postgres    false    220            X           2606    57868    order_items order_items_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_id, product_id);
 F   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_pkey;
       public            postgres    false    221    221            d           2606    90704 *   order_payment_info order_payment_info_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.order_payment_info
    ADD CONSTRAINT order_payment_info_pkey PRIMARY KEY (order_id);
 T   ALTER TABLE ONLY public.order_payment_info DROP CONSTRAINT order_payment_info_pkey;
       public            postgres    false    229            ^           2606    82471 .   prebuilt_order_items prebuilt_order_items_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.prebuilt_order_items
    ADD CONSTRAINT prebuilt_order_items_pkey PRIMARY KEY (order_id, build_id);
 X   ALTER TABLE ONLY public.prebuilt_order_items DROP CONSTRAINT prebuilt_order_items_pkey;
       public            postgres    false    225    225            \           2606    74236    prebuilt prebuilt_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.prebuilt
    ADD CONSTRAINT prebuilt_pkey PRIMARY KEY (build_id);
 @   ALTER TABLE ONLY public.prebuilt DROP CONSTRAINT prebuilt_pkey;
       public            postgres    false    224            N           2606    57837    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    216            T           2606    57853    traffics traffics_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.traffics
    ADD CONSTRAINT traffics_pkey PRIMARY KEY (traffic_id);
 @   ALTER TABLE ONLY public.traffics DROP CONSTRAINT traffics_pkey;
       public            postgres    false    219            P           2606    57846    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    217            R           2606    57844    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    217            k           2606    90662 #   cart_items cart_items_build_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_build_id_fkey FOREIGN KEY (build_id) REFERENCES public.prebuilt(build_id);
 M   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_build_id_fkey;
       public          postgres    false    227    4700    224            l           2606    90657 %   cart_items cart_items_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);
 O   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_product_id_fkey;
       public          postgres    false    227    4686    216            m           2606    90652 "   cart_items cart_items_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 L   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_user_id_fkey;
       public          postgres    false    4690    227    217            h           2606    66041 !   feedbacks feedbacks_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.order_details(order_id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.feedbacks DROP CONSTRAINT feedbacks_order_id_fkey;
       public          postgres    false    222    220    4694            n           2606    90695 5   order_delivery_info order_delivery_info_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_delivery_info
    ADD CONSTRAINT order_delivery_info_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.order_details(order_id) ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.order_delivery_info DROP CONSTRAINT order_delivery_info_order_id_fkey;
       public          postgres    false    220    4694    228            e           2606    57859 (   order_details order_details_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_details
    ADD CONSTRAINT order_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 R   ALTER TABLE ONLY public.order_details DROP CONSTRAINT order_details_user_id_fkey;
       public          postgres    false    217    220    4690            f           2606    57869 %   order_items order_items_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.order_details(order_id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_order_id_fkey;
       public          postgres    false    221    4694    220            g           2606    57874 '   order_items order_items_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_product_id_fkey;
       public          postgres    false    221    4686    216            o           2606    90705 3   order_payment_info order_payment_info_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_payment_info
    ADD CONSTRAINT order_payment_info_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.order_details(order_id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.order_payment_info DROP CONSTRAINT order_payment_info_order_id_fkey;
       public          postgres    false    220    4694    229            i           2606    82477 7   prebuilt_order_items prebuilt_order_items_build_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prebuilt_order_items
    ADD CONSTRAINT prebuilt_order_items_build_id_fkey FOREIGN KEY (build_id) REFERENCES public.prebuilt(build_id) ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.prebuilt_order_items DROP CONSTRAINT prebuilt_order_items_build_id_fkey;
       public          postgres    false    224    225    4700            j           2606    82472 7   prebuilt_order_items prebuilt_order_items_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prebuilt_order_items
    ADD CONSTRAINT prebuilt_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.order_details(order_id) ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.prebuilt_order_items DROP CONSTRAINT prebuilt_order_items_order_id_fkey;
       public          postgres    false    4694    225    220               �   x��̹� ��P�ۿW�@� �	�3�N&)��rũܾ�F�Tey����'��3<�@ȇp�ڹ��&-(&+h�2�ѽ�I�2�o��
��� w)-�z��W�=�!�]=��e�W�1~��0�         2  x�U�=Nf1E����;��$z$��qF��}L1)��:����E*1� K�]�S>������q}X��7jѩ�j`+̚�4����������,8ٴ ��<v��� �O�|ɒ�������6���zL�UD����Z�D�2W��M��^�,!�IQ"yv�Q���Ǡ>ii=��������v�E$��Y[su/��?����v���}1(9�V�@���S�����#p�Ct��}X�����ߍ"d�[N�#�weAVO��>	ɇ�T��k�iUa��6#}|ǟ_�����y�_韀e         _   x�K1�L5J46ֵ4H��5IK5�MJ40�M�0LJKKM66�L�415S�J�I�S�M-JI�N,��.�|JsJ�P9��F��@����D�=... 5+         �  x���;��0���)�\�%Qr�k�%�J��?Bod�l�\X�>���hX�f+0�,[6�����Y)׍��k�}�������l�l���Cq0��U����JƢ��j0���g�S*7�S�8��=bMu�E
w��ՓS�)Q�f����j*�9|��~R��#4Q�	�6�
)�u9�Zim� ����BW+�{k�����Ok�i�5�_W4�&�sy�C��k�E�@Qz�L�Ţ8�u��G>��'�:6��l����S��0]�N�8Ҙ�-ݢH�2�N� 6{�:d5~po�N|���"������]������Cۼs�C���JF�;q٩�Z��������)�=8W��ɯ�`���Stm����̌"#z�:ˑ��ן���V����p�	V�vg/��������҃e=xHZ��r�GZ��c���C���˩��{/b*�1}}?��7�$0         =  x���ˑ�*�uw.�%�@R.�1����pz�o��S2B+묔E����tz�$�X1��l��#�?�W!��# 5�S���R4U��R)�:���R���-D��q��lzzlR]�f�i�[
S�S��`�L3��L5���!p�m��e��iw�\N�e�G�_���Χ[Sm_���S�Q�7!F�U^,=��=����٘���۩,���O�����ȷ 5���4�Y(UtT�jxjt85���G�Ϡ�"�X7U�"i��G{֝-�8��	�P�&L�}���¨�몽ô��3g���_�g_�j�HcVit��TS������:�	�;[��0U�V�Ӏ[��ݳ^�}N�A��"�T�t�<ӂǶ����RI�Z�i��U(��`*	S�i����z����L��ild�sR���Y}����I�QQ�N�-�w� �����}c�nB��M����Z���I=�о�R���ͣ�[q��QU8����fC�
\�w'W@���^0�&�1������p�C�yRt�5d��8��S��b���B�rC��яQ/85��[�����5�         \   x�%��	�0 �I6���$�k~Vݼ�7 30[*�&��VGX<�R����m��i���tW��FV �˨:2�I����n         E  x����r�8������f/f�<s���hh�u��������k�Ԑ�L<S��۠d��D���������ެ�ʼ^oQ��$��#JI��������?����@7���8�@����/>�eK
4�j��5�66����]M��/`3�
�?�w��%���r���vK�CUnH��2�������>�-1�˂�e�B�(ʋ"�7����.��lNY�A)��뼮��~�#3��q��"��ۍe��"pMNkt�aP�yK��3�����:���Ϻ�khڪD�}���I޴h4Z��5d���5�uŦ�Ϸ����5��y���i�mK�!�Qc���m��Ԡ񺠻��6�뜖�����B��:%8$���8��pįd�}�s!R��V�O3n�kZ5m^���ctNo?-�1��mw���۶�����G�tE��G�D�+Z}|��Ư��>W���_��ba��Ğe��阾eX=���+��Y��`�p�7���n!���s�l@ dK �X�����2�4�8S���,�Q��y�V([Ƌ#I��2�/�E�R 4�V5h�}�}1�,;P2�`iO�$B!�#��W���?����$�6G�1�� 5��`W�M`�G<������sj<5�*��~�
i���~��������o���/��>*�/n�\��^`B�Ob!�K9��N��aπ� ��@1�>�xP�R�h��-��3Rl���-_~'%r��v�1q�;`'!�0:S�~*��I�`[��-�`z�,� s������"F���Oȕ��� ���t���`_ ?LI�!�ޤ1l�#2�ظ�dt����)�j���g-��#<�
�@�jz��/%�v����#W���P��kD�X���1�������x�K4�'�)�ҏ4��N�ޥ(�����k�1��.U��%89Z�L��,�
��?�'��z�i�4pgLݓ�:�)P� 'p��50y��WR3sB�������/�n�%��p��P
ҳ�I���	2N{��Lm�$φU��nK���T��������=iÁ�TO�����Qx�	|Q�X��"R�g��:���֛CH,�ь4[�v������˞��oh��OhYA�PC�{���CgIt��l �Hl]̍���r\�g h��١7fs~��z&h��+������:.c�c��my�c����&㓡$>�Z||[>6.�(���y5~�W��>�l�ߞ���$rL}T$����&b���B�Ƽ�~6okZ��2�;qd��#>MOɷ���W�4�4 E�g���i�7���Ѝ��N{��Ƒe�����ߕg�O\���9;���x�e�d�H(y��V��2�]�� �L��=��I�u��5ք	�����&=�<��Y:�����.2L����cAʩ�0��RJgj4���(��]��U�7���W�����U<�cD(�cG�9|rR5~�C���P �����An�Ev�&//���N�"�׬��Ib����V�����$��l����ザD}n���V�5��c�@����K���HYN�4L�ʆ��6�������C���A�M>r$I���[��i��Z��ڱ�~`�$j�����V)��K�ԍ�/�'�p ޲��	F� Y�?�x�R�dY�t�5]�����`�(|�M��B;����|$y	�a���m9�B��0�вq8����2�e#,~�N�LEA�
	��s$��bGʯնD���y�;���Q�XWj{19%���@(M�"^��"dx g�Y=���8��q�)d�6W����Q G��Q'��պ��h>���f:(y�	�j�5J<HEI�Q��;Sϩ�-;<W������?X�l5�PF�G��Q��h7�CݿP��V׃I�,�������3't���N���"�gә)p��9�w���b�<���b6�.�D�s2�U ��U<��wl݌EEr�Kq��I��M�g��/���R���99V@����){������]�&K�J�ŭ�-�5�KW(�;u��%�~����������4����a�Lˮ ��F2y�b�_B�_�U��N}1��%����\L/���!'��D�QK�p^qY䐲R���N�d�WBۑ_i�¤&�-���Y�0�0��s��Qc��:Y:(�Dׯ�<.`H���"y`FL�g9 ]L��>�'�F�WRTP���A�m��9D�"�$S�$��H�Po�IR���C�=�p�P��b~ ��^�}�,���؜��<?�f��Q����|q"�R����0p�]W�U�J�#���6T��t�x�l�B$�#\��&l2;�ީ{������.��i���x�R�u�Ұ�I�9ѡ9����� ��68�n��G��/PXê�`4�T���u�=�ն�i��IVx���	ێ|턺��#k~��M�={�мN������<�]w��k.���\vt���I�����V�ͺ+enq>�i,��_k�Q�q�����6�i�-UA�����sn�b?���W�%5}&u�����	���	�����P�3#�F��n����Q�yx�Ǌ� (_��t�y� y,`(��^�:��F�T1$�89���Hm$��a�R�H�ݕMXq:��ݚ�]�>L�d����H�E<�Y�l��"#8� G�A�
㒀1��<y�)���#��Q!WhDg�K��_�[�����Gx%v���R4���"յ-0F��]p����Z��P,�E��7HR#�#'�����!+���&|̐y����BN��zݖ{h�a��Y8���5��W���A�֜�Zs��8�ȶ,�6"��w��$��}+����3�oM�U�C-���,�b.2�����kdWIW��p� y9�S@�Oq$<�8>i�΋�6-���M/N����c���b/�j�E��x&D�2xJ���Ԅ�{����$<��؆�z�S�$Ҙ}�$�fG�o E`F�pгُ�(��5(�F���&	U�`�鑣)�\�z_-̔i��\�ZNh;�����b���t������`#�!Fةg/���m���m{�ZHܞ�I�R�$��8��������H;?�!�^�	�|���!i�P��0�Pf�ƗI�$��b�(�|��-J���sU�Wx{�ݤp^�Ci�ܼ����e��=7
���B#����aCǓ�O�i1}�;�b��>g��)�CU��A���Ur�m��MMw�Ex�/=��=ru}�	{�j��L�v}�L7Z���G��Ďo�]�tp$E8��2V9�,�D�����B�����iX�3�l�l�h�2�,</�lD�����K�F��� �!�a�Q(F?P"�U�4�`��Ax̯�*��� ���`߼r��8.��������.^\r      	   f   x���!���¾����"����d�s�"o��H�'�&POio}�+j�^NR�)����3^�hc��Y^s3��?o�bC�lĽ��|��m���{�J\             x��\Ys�Ȗ~�~E����
L���f��p%�VU�%�6cY�"��ܿ��\�dW����K����̳/��Y��,CK������f;4�_��� 9�����E�!�q�O�����[��f��S����,���O|��Ȏ�o�g�����o��)}�N��}�E@0AH�L*�Y�,�3D������*T���J�yzJ��l7I�-����=m��Mc��������x����)�=���;Z��ٰpa��B�>����ݠ�=4��?���x}�D�zAN����^�h��go�M��jY#���\,zA�k�z^������3��Ŵ~
�u��#-�������^�"A�����7$f}�x�l���5ٟ���g�G�X3؂�>v�>sB��&��-ٿ������c������`cʰ���h�����r�0񼘨E'^�9$�\Pg�Y�(�կ1��+��l����@xfw[�`x�sY%�����`?o�Y���H�Kya4����Z�H��)��9KO���s��k��7��O�vA�6�:��9�<ߧ�'���Zn끡�J���zQ��dblEY�ԑfըI��	���V8äx��3j�k6��>�幂;\mZ�s�3.��;4L���m�H��e�78qᘰ�sы���K
��M�����<���Xa���!; �ߐp�Y�Q��s�f4܏������9���|	��(m�M��ڿ=';�!
�g�����B]����D�7�� ��*v'pcLP�0G�zc�b�
�X���x�Y~ȶ�k�a��w`�����54%v�tD�
�i���ha⻡���\g��}*}9i/4��=u	�g ���2u� *=9�&ZM�+)��LL�e�} ��0M����x �Y~�;]J�l�n�������O�~��
��g�[(�n(�>�+�L�m|���ZS��˄�.��
����n����E�<U���>}ɷX[�>�ԯ�˻C���M��S�xJZ����ډ�B��a���6��I4�O�h�{�l��g��f��YZ5���%�� �JF�y�K�<��-%E!���Qe�JX�J72u�y�����%�^А�KOո�a��B�)�x�J�E�Z��n8�L�����f���
Iz`j�庹U�%ay�Ă�����>9<�8-~�!�:��Jd��q�'s��4����J��#Z�u���d��͙��t#�,���濧�#V���<0���
�v��.a7x���S�����n��,Р�h���@�S�R����/����4�^�1A��/�	�'�"�O���;�5�kd_^n��z�-q��W4XS��������hy�Rg�|�!Z廗�����5O�#�6냓B����	�����R��x0Ms��a�!.������| Vgt�����4��7ŕۏ�0@���l��p�pWLYd�����D^
�M8�M��o���!�	ם�����k
��AB�{a�%w��f�'��]��2�2�%+<�C�
���4t��z��^�zpo���04�wL+��A���i�s
x�pBH�߷�t���ң�OO�2}�x�����4%�@`���}j��F��o~M	�PF��̍��]�� �=���T e�P��|W*��f�l}*����d(����p�`��y�D��>n�r�Y%f���C�@���hwC׉����gC &�R�	�k��� S�?�<�n�n�\�<f�����P������3��Dh}�X�GHpM�ZU����!�C���]@b����1�����F����F/�p���Dk�8��nF]���lܓNb���1�y��7se�e��A��#���0Xik�ٍ���9�H1�M����ȱ���3��0t��$h"]��)n�D�إ��%�h#.ŧ*�)VƮ��p���49��
\M�#��^In�����t>�}Z�����|��d{z��=�Ұ����n`Ѫ �7�m��ͺU�S��K!�)�u��m�dc�o�f��<���R��G)-UX�?�4yLΟ���}!Q�;s}�P�.�n����i2���fMT�!�NyY�:� �,�Nh�\��j6�
���r���jr6���:�O�E�;��_E��$\���b��Y~���t'�hs�I�B�2C�ټ��&�h���gDt�I ��L���L��k�������JS庙�~Ժw�4���������(��$ۛ�27��&7�K�o���8=���ʚsSsx�k�^v��X(Gz3�`�Z��Dl&��GY��P˻��8Z�T��*�TIQM�p �a:�G��-��V�UT}.���X�E��3�\�J����6����r���y�U|ϓ���Ip�}�U�׿& A�g���a}J�=�������qf���!�&\���ByؓCKr���s�V�x3�>#���JO[�L{BXI�����R��?=�Uh�LEڂ�i�u_Z�y�17��Rw״�L�B�[�+%��d�YM����U$���(��x�}�h��-�ƞ_Ӣ]�k!��U�	��(Aۂ^E'�l��f��i����a�uf˞�й���))��G�ۯ��\n���D�M�ٚ�U�(�ZOg��էd�z���~��A�3��y��y��ţ�� h���	b�a�Y�;��<PB;�V��H���<h	/d�!��]{*h]���S����z�TU�ẐU�i�T6I`{rX�uC�yA��"+.2.4��^i�:�M�E������tP�ºDk/4|�5�<��&z��@}Yb#��L'i�9�K��!S%E�~�+xP�K��0O?@�����PG/_Q�c�6��o%���FU����|u�䡱�v5��q5h�!;���	�i�~���u?��!�ĹUH�m��6�~�ץ�T��IQ$��c�.q1�US����t��
w�3?�->ٯ�;([�m�aݸ��]��?'?^>�6����6�nT��)�\&��ڦ~�Q��ɏ���-d�3Y��+
�p.�3�g�tc���J53]�S`Bu)Sb����UFQ#�c�79�~����xۧ����ם��������X�&�n�n�����T$�{�̀�%TrX�I$.I=b�f�ޠ���T�-����C��c֓)ݸԙ'?��S&�7H�h��aA���2G+:�!D<����J�* *����Ѹ�ʶ�*w:����j�cR<:�m#�n�Z��'^�4fS��ջ�+�6mRݠ~mN���";� -.t,	�왧ڗ�}�\����XJt�j��j���%5�h})4�\��$�ӴĻT�8{�⪂a�va��������-��o�g��-�@=��Q���l� 2KW�����tWD�"/$k���!%��}�ߊ������=�q��9ө&C7��40.������?+�e��J��iv����_�{<�(�{-n0�24�M!����X�F'��261���[�[�l�/w�e�N�ƪV��#3��%�3Pop�hx%�F�Յs�E1aR_�8�]:ɒ�I��:{{����A��DU��m��l(h,���l� �`ۜ
(i�Z��IЪ-M�}�<*����6T���̬�q�!�u����w�!ZK|�����+���$��\尴.c�
�+�m��V�T�n��%=��O�H�9c9WʪAݾ��U�	Dh��A��<�i�I��&�~/3�}]4/���+D�e�Ӏ�@���O�B���h5�ƫ%8��Z�%�s�Jg�e+2�v�3N�b��(:��1;�A�V��<5��z�����:.��	���D��1������֕9+Z.
�7R�GR�&�K�빠��9��H`��`�	(�r��� V�%�fR���攒|��h%�j���ʮZ=�${jer��*9mau:�jE=�4�_��,��m;��BS�i�/��,���7�k覧(�p������p�ǁT�3��+�k���)�iz�?%!PE.=n�]�M��ǩ�����.# #6����3q׷��m��Qm|�`%   �[���d�4����*2V���%?��������aٺ���$��P���'P��|n$��*�*����wt�B�����_eq���nJ�\�E�
��9�|}7��E���R �$��=%������C鍥���3A��=�<�����Ąu;X7�YΖ�2����P�_>5��2��u2��K��#j�؂rTM�ט��F�I��c��ˇ���=Ҥ�7��SE�+=�;L�+�L2�i��v|Z�{9��r���8/�.�r����|�|M7-��Hz��nG��~��L���S�T��ا�;)	<��J�]�9�1	ڎ.�0ύ�R��a��vQ@�ۉ�C�z���!��t(לA|�pi����N�կ)Dr���Z�1�!���"�x���#?�Z;�\�lM�M�f7"k#��R/����w�&Z���<�|��# >\Tɇ^�'x��"M��M�\?�8�=w�e�};��~�p��u�"&�֦�i���NĠu�ҚM�=�榬��6�N��% \�d- ���)�����^�D[�J\!�Wh�u�agz8�{�ۋe�DD�w��&���x`�H�%-P@�6(eD623�ذ��@9��6(�LR��nP��qT��.�ؿ1���@)��P�>)b�u��KF����T��)a?}؍�_r����+�p�f����*�**�(�{Q��	�Q�<�/g4�Ax�6��KD����-���C��1/��v��G�!ڌV��j02#��~(dM�4�;O��"-�eyI��V���.Q�O��p70����&��}�K��z��}h��Ac�!��`��<��E70����I����H�Ng�V7����CO�̒�^�]8�$;�H�G���k}��/��Z��~P��w&�,ڢ��+W4&�dOy��j7fp�>$�g]_{�X�=�P�35f���9�4�5�a��q-�� 24�J��R�r:D��9��і�����v��:���np�@���j��$�=pZ��Ͷ}�^�����z�ܜ���Y����6ej�4d�	|H���\/BO�6Ϸw���~Gԝ��Aۚ�+�0 �������e�Y�O����,���1;e��>t�}�P9��y�w.:��D������´w��;q��NH�y�Sm_�m�s��Z�� ԛ���UP��h�Y�Q<\m՛���a:��z<��QF�_����l��}��85���;�\A��	��S�+%oSd���^���C ��a�sl�ׅ���/_�]��         �   x�Eѻ�0К��9�Y�d�9B:wF'��(����Υ����#��

�y7����ް��[����lWch�8+���H)\�\�t��E8\���t��K�����-J0ACSPKK@���*di	di
j�������e)�,MA:d�#�,-� KK0�-MA~����S�           x����r�8���S��2���-ZY�����A�s���Ų#�R3U8�Y`W���I� A��Q(@J�����)A��,j�E�]D������Vz߰��o�b;)����������f߈"��<�+D��y��̚��m������R��˄A�	��1 ���SU�7/��:M	�Wy�:�g`�2�E ����I$�X������!�b���		�ԒP�W2�KPP�u�:5�����U*��
���<�&��jR>�g�Y*�!A�#zc�z/��{ʞ�=��>�N����j�^��#Y�q8�m�7w�G]lf,�_�<��4:b]^�#d^ق`Sr�I�!�6��">�m?�-B��'��U�u*�O ��Q+z��������QV�x�(�� ��nw�j"�W5�,9z|�L1h���_Y߁0$�Y6w@*�Z� |�i�og9����Iߚ�k�Lz-����C�R�#�P߁J0�S�)HUU�ߣ?ix�{���W�|7�D��}ӣ,�u�������ᰌ�q�y8;��!H�<Səa�[;��,��e`v{��e6~��Bhzc^�� ;;W�:T��qu[�J�i�(!ײQIB*��(�	=a؇�B����M���� Tɦ;�7Y�#����d�x��3�.�L�vm�m��f5�=o��˺c�st>�H����,˧L�K��T�,s�M*�����L��_e!L�V��ڮ�h[b�ﾝ�7#��|���fh�z�Uû���%��^��l����
���N��x��q]*U���;��ܷ�ӋʷBȱ���¦A`I)P�y87���=�'�y߷:�z~tg0��wӺ��v��w�^��z����{�z�n�1Xht�J�aͪ�q �1�m�5�F�4r}�^^�]d�[�b��6Q����W��^Y����-B�(�@��_��0��V����� kʖnj��p��"�|�����-O��|<���ٸ7{L�~�
幻~���)��)�v����&�W�:�`?�2P[��?���L?[777��os     